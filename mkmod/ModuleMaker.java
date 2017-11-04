import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

public class ModuleMaker {
  private static final String TEMPLATE_SRC = "system-verilog.txt";

  public static void main(String[] args) {
    String name = "";
    String netlist = "";
    String def_ports = "";

    if (args.length >= 1) {
      name = args[0];
      if (args.length >= 2) {
        List<Port> ports = new ArrayList<>();
        for (int i = 1; i < args.length; i++) {
          Port port = readPortArg(args[i]);
        }
      }
    } else {
      System.out.println("USAGE: java -jar mod.jar <module name> [port name[(size)]...]");
    }

    setup();
  }

  private static String setup() {
    StringBuilder buil = new StringBuilder();
    String line;
    InputStream inputStream = (ModuleMaker.class).getClassLoader().getResourceAsStream(TEMPLATE_SRC);
    try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream))) {
      while ((line = bufferedReader.readLine()) != null) {
        buil.append(line);
      }
    } catch (IOException e) {
      System.out.println(String.format("ERROR: cannot process template file <%s>",
        TEMPLATE_SRC));
    }
    return buil.toString();
  }

  private static Port readPortArg(String def) {
    char c;
    boolean isSized = false;
    StringBuilder buil_size = new StringBuilder();
    StringBuilder buil_name = new StringBuilder();
    for (int i = 0; i < def.length(); i++) {
      c = def.charAt(i);
      if (isSized) buil_size.append(c);
      else buil_name.append(c);
      isSized = (isSized || c == '(');
    }

    int size;
    isSized = (isSized && (def.charAt(def.length() - 1) == ')'));
    if (isSized) {
      String s = buil_size.toString();
      try {
        size = Integer.parseInt(s);
      } catch(NumberFormatException e) {
        size = 0;
      }
    } else size = 0;

    String name = buil_name.toString();
    return new Port(name, size);
  }

  private static class Port {
    private String name;
    private int size;

    public Port(String name, int size) {
      this.name = name;
      this.size = size;
    }

    public String name() {
      return this.name;
    }

    public int size() {
      return this.size;
    }
  }
}
