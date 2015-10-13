package RDSAnalyst;

import javax.imageio.ImageIO;
import javax.swing.*;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;

public class SplashWindow extends Window{
	public SplashWindow(){
		super(null);
		this.setSize(new Dimension(512,513));
		this.setBackground(new Color(0, 0, 0, 0));
		this.setLocationRelativeTo(null);
		final Window win = this;
		BufferedImage img;
		try {
			URL url = new RDSAnalyst().getClass().getResource("/icons/RDSAnalystSplash.png");
			img = ImageIO.read(url);
			JLabel lab = new JLabel(new ImageIcon(img));
			this.add(lab);
			lab.addMouseListener(new MouseListener(){

				public void mouseClicked(MouseEvent arg0) {
					win.setVisible(false);
				}
				public void mouseEntered(MouseEvent arg0) {}
				public void mouseExited(MouseEvent arg0) {}
				public void mousePressed(MouseEvent arg0) {}
				public void mouseReleased(MouseEvent arg0) {
					win.setVisible(false);
				}
				
			});
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.setAlwaysOnTop(true);
		this.setVisible(true);
		new Thread(new Runnable(){

			public void run() {
				try{
					Thread.sleep(4000);
					win.setVisible(false);
				}catch(Exception e){
					
				}
			}
			
		}).start();
	}
}