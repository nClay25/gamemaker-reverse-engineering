import java.io.*;
import java.util.regex.*;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.symbol.SourceType;
import ghidra.program.model.listing.Function;
import ghidra.program.model.address.Address;

public class import_builtins extends GhidraScript {

    @Override
    public void run() throws Exception {

        String filePath = "/home/anon/Desktop/Reverse engineering/void stranger/builtins.txt";
        BufferedReader br = new BufferedReader(new FileReader(filePath));

        Pattern pattern = Pattern.compile("func=(0x[0-9A-Fa-f]+).*?\"([^\"]+)\"");
        String line;

        while ((line = br.readLine()) != null) {

            Matcher matcher = pattern.matcher(line);
            if (!matcher.find())
                continue;

            String addrStr = matcher.group(1);
            String name = matcher.group(2);

            // Prefix to avoid collisions
            String finalName = "gm_" + name;

            Address addr = currentProgram.getAddressFactory().getAddress(addrStr);
            Function func = getFunctionAt(addr);

            if (func != null) {

                try {
                    func.setName(finalName, SourceType.USER_DEFINED);
                    println("Renamed: " + addrStr + " -> " + finalName);
                } catch (Exception e) {
                    println("Failed rename at: " + addrStr);
                }

            } else {
                println("No function at: " + addrStr);
            }
        }

        br.close();
    }
}