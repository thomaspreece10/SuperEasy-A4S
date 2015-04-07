// A4S.java
// Copyright (c) MIT Media Laboratory, 2013
//
// Helper app that runs an HTTP server allowing Scratch to communicate with
// Arduino boards running the Firmata firmware (StandardFirmata example).
//
// Note: the Scratch extension mechanism is a work-in-progress and still
// evolving. This code will need updates to work with future version of Scratch.
//
// Based on HTTPExtensionExample by John Maloney. Adapted for Arduino and
// Firmata by David Mellis.
//
// Inspired by Tom Lauwers Finch/Hummingbird server and Conner Hudson's Snap extensions.

import java.io.*;
import java.net.*;
import java.util.*;

import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import gnu.io.SerialPortEvent;
import gnu.io.SerialPortEventListener;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.UnsupportedCommOperationException;

import org.firmata.Firmata;

public class A4S {
	private static int[] firmataPinModes={Firmata.INPUT,Firmata.OUTPUT,Firmata.ANALOG,Firmata.PWM,Firmata.SERVO };
    	private static String[] a4sPinModes={"Digital%20Input", "Digital%20Output","Analog%20Input","Analog%20Output%28PWM%29","Servo"};

	private static final int PORT = 12345; // set to your extension's port number
	private static int volume = 8; // replace with your extension's data, if any

	private static InputStream sockIn;
	private static OutputStream sockOut;

	private static SerialPort serialPort;
	private static Firmata arduino;
	
	private static SerialReader reader;
	private static int Baud = -1; //Default Baud Rate
	
	public static class SerialReader implements SerialPortEventListener {
		public void serialEvent(SerialPortEvent e) {
			try {
				while (serialPort.getInputStream().available() > 0) {
					int n = serialPort.getInputStream().read();
					//System.out.println(">" + n);
					arduino.processInput(n);
				}
			} catch (IOException err) {
				System.err.println(err);
				System.err.flush();
			}
		}
	}

	public static class FirmataWriter implements Firmata.Writer {
		public void write(int val) {
			try {
				//System.out.println("<" + val);
				serialPort.getOutputStream().write(val);
			} catch (IOException err) {
				System.err.println(err);
				System.err.flush();
			}
		}
	}

	public static void main(String[] args) throws IOException {
		try {
			if (args.length < 1) {
				System.err.println("Please specify serial port on command line.");
				System.err.flush();
				return;
			}else if (args.length < 2){
				System.err.println("Please specify baud rate for serial port on command line.");
				System.err.println("Baud rate can be any one of 300 1200 2400 4800 9600 14400 19200 28800 38400 57600 115200. The typical value is 57600");
				System.err.flush();
				return;				
			}else {
				Baud = Integer.parseInt(args[1]);
			}
			
			if (Baud!=300 && Baud!=1200 && Baud!=2400 && Baud!=4800 && Baud!=9600 && Baud!=14400 && Baud!=19200 && Baud!=28800 && Baud!=38400 && Baud!=57600 && Baud!=115200){
				System.err.println("Invalid baud rate");
				System.err.println("Baud rate can be any one of 300 1200 2400 4800 9600 14400 19200 28800 38400 57600 115200. The typical value is 57600");
				System.err.flush();
				return;				
			}
			System.out.println("Baud: "+Baud);
			System.out.flush();
			
			CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier(args[0]);
			CommPort commPort = portIdentifier.open("A4S",2000);

			if ( commPort instanceof SerialPort )
			{
				serialPort = (SerialPort) commPort;
				serialPort.setSerialPortParams(Baud,SerialPort.DATABITS_8,SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);

				arduino = new Firmata(new FirmataWriter());
				reader = new SerialReader();
				
				serialPort.addEventListener(reader);
				serialPort.notifyOnDataAvailable(true);
				
				try {
					Thread.sleep(3000); // let bootloader timeout
				} catch (InterruptedException e) {}
				
				arduino.init();
			}
			else
			{
				System.out.println("Error: Only serial ports are handled by this example.");
				System.out.flush();
				return;
			}
		} catch (Exception e) {
			System.err.println(e);
			System.out.flush();
			return;
		}
		
		InetAddress addr = InetAddress.getLocalHost();
		System.out.println("HTTPScratchExtension helper app started on " + addr.toString() +":"+PORT);
		System.out.flush();
		System.out.println("Ready");
		System.out.flush();
		
		ServerSocket serverSock = new ServerSocket(PORT);
		while (true) {
			Socket sock = serverSock.accept();
			sockIn = sock.getInputStream();
			sockOut = sock.getOutputStream();
			try {
				handleRequest();
			} catch (Exception e) {
				e.printStackTrace(System.err);
				sendResponse("unknown server error");
			}
			sock.close();
		}
	}

	private static void handleRequest() throws IOException {
		String httpBuf = "";
		int i;

		// read data until the first HTTP header line is complete (i.e. a '\n' is seen)
		while ((i = httpBuf.indexOf('\n')) < 0) {
			byte[] buf = new byte[5000];
			int bytes_read = sockIn.read(buf, 0, buf.length);
			if (bytes_read < 0) {
				System.out.println("Socket closed; no HTTP header.");
				System.out.flush();
				return;
			}
			httpBuf += new String(Arrays.copyOf(buf, bytes_read));
		}
		
		String header = httpBuf.substring(0, i);
		if (header.indexOf("GET ") != 0) {
			System.out.println("This server only handles HTTP GET requests.");
			System.out.flush();
			return;
		}
		i = header.indexOf("HTTP/1");
		if (i < 0) {
			System.out.println("Bad HTTP GET header.");
			System.out.flush();
			return;
		}
		header = header.substring(5, i - 1);
		if (header.equals("favicon.ico")) return; // igore browser favicon.ico requests
		else if (header.equals("crossdomain.xml")) sendPolicyFile();
		else if (header.length() == 0) doHelp();
		else doCommand(header);
	}

	private static void sendPolicyFile() {
		// Send a Flash null-teriminated cross-domain policy file.
		String policyFile =
			"<cross-domain-policy>\n" +
			"  <allow-access-from domain=\"*\" to-ports=\"" + PORT + "\"/>\n" +
			"</cross-domain-policy>\n\0";
		sendResponse(policyFile);
	}

	private static void sendResponse(String s) {
		String crlf = "\r\n";
		String httpResponse = "HTTP/1.1 200 OK" + crlf;
		httpResponse += "Content-Type: text/html; charset=ISO-8859-1" + crlf;
		httpResponse += "Access-Control-Allow-Origin: *" + crlf;
		httpResponse += crlf;
		httpResponse += s + crlf;
		try {
			byte[] outBuf = httpResponse.getBytes();
			sockOut.write(outBuf, 0, outBuf.length);
		} catch (Exception ignored) { }
	}
	
	private static void doCommand(String cmdAndArgs) {
		// Essential: handle commands understood by this server
		String response = "okay";
		String[] parts = cmdAndArgs.split("/");
		String cmd = parts[0];
		
		//System.out.print(cmdAndArgs);
		if (cmd.equals("pinOutput")) {
			arduino.pinMode(Integer.parseInt(parts[1]), Firmata.OUTPUT);
		} else if (cmd.equals("pinInput")) {
			arduino.pinMode(Integer.parseInt(parts[1]), Firmata.INPUT);
		} else if (cmd.equals("pinHigh")) {
			arduino.digitalWrite(Integer.parseInt(parts[1]), Firmata.HIGH);
		} else if (cmd.equals("pinLow")) {
			arduino.digitalWrite(Integer.parseInt(parts[1]), Firmata.LOW);
		} else if (cmd.equals("pinMode")) {
			arduino.pinMode(Integer.parseInt(parts[1]), getFirmataPinMode(parts[2]) );
		} else if (cmd.equals("digitalWrite")) {
			arduino.digitalWrite(Integer.parseInt(parts[1]), "high".equals(parts[2]) ? Firmata.HIGH : Firmata.LOW);
		} else if (cmd.equals("analogWrite")) {
			arduino.analogWrite(Integer.parseInt(parts[1]), Integer.parseInt(parts[2]));
		} else if (cmd.equals("servoWrite")) {
			arduino.servoWrite(Integer.parseInt(parts[1]), Integer.parseInt(parts[2]));
		} else if (cmd.equals("poll")) {
			// set response to a collection of sensor, value pairs, one pair per line
			// in this example there is only one sensor, "volume"
			//response = "volume " + volume + "\n";
			response = "";
			for (int i = 2; i <= 13; i++) {
				response += "digitalRead/" + i + " " + (arduino.digitalRead(i) == Firmata.HIGH ? "true" : "false") + "\n";
			}
			for (int i = 0; i <= 13; i++) {
				response += "analogRead/" + i + " " + (arduino.analogRead(i)) + "\n";
			}
		} else {
			response = "unknown command: " + cmd;
		}
		//System.out.println(" " + response);
		sendResponse(response);
	}
	private static int getFirmataPinMode(String a4sPinMode){
		int idx=0;
		while (idx < a4sPinModes.length-1 && (! a4sPinMode.equals(a4sPinModes[idx]))) idx++;
		if (! a4sPinMode.equals(a4sPinModes[idx]) ) idx=0;
		return firmataPinModes[idx];
	}
	private static void doHelp() {
		// Optional: return a list of commands understood by this server
		String help = "HTTP Extension Example Server<br><br>";
		sendResponse(help);
	}

}
