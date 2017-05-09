import com.support.bonitasoft.autogen.TestC;
import java.io.FileOutputStream;
import java.io.IOException;
import com.thoughtworks.xstream.*;

public class GenerateXML {
  public static void main(String[] args) {
    TestC testc = new TestC();
    FileOutputStream fos = null;
    try {
      XStream xstream = new XStream();
      fos = new FileOutputStream("inputObject.xml");
      fos.write("<?xml version=\"1.0\"?>".getBytes("UTF-8")); 
      String xml = xstream.toXML(testc);
      byte[] bytes = xml.getBytes("UTF-8");
      fos.write(bytes);
    } catch(Exception e) {
      e.printStackTrace();
    } finally {
      if(fos!=null) {
        try{ 
          fos.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
  }
}
