import java.awt.*;
import java.awt.event.*;
rob=Robot;

pause(5);

for i=1:10,
    rob.keyPress(KeyEvent.VK_0);
    rob.keyPress(KeyEvent.VK_DECIMAL);
    rob.keyPress(KeyEvent.VK_0);
    rob.keyPress(KeyEvent.VK_ENTER);
    pause(3);
end
