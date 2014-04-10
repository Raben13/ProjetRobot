# -*- coding: utf-8 -*-
'''
Created on 15 f�vr. 2014

@author: Adam
'''
from visual import *
from visual.controls import *
import math
from Dessin import *

class Interface3d():
    def __init__(self):
        
        self.scene_camera = display(title='Vue de la caméra',x=810, y=0, width=800, height=500,center=(3,0,4), background=(1,1,1))
        self.scene_robot = display(title='Vue du Robot', x=0, y=0, width=800, height=500, center=(2,0,3), background=(1,1,1))
        self.scene_robot.bind('mousedown', self.grab) 
        
        
        #Determination du point du centre du socle et du premier axe
        self.axe0 = (1,-1,2)
        
        
        #Determination des angles min, max et courant de chaque bras du robot
        
        self.angle_Z =0
        self.anglemaxZ = 360
        self.angleminZ = 0
        self.angle_bras1 =90
        self.anglemax1 = 360
        self.anglemin1 = 0
        self.angle_bras2 = 50
        self.anglemax2 = 190
        self.anglemin2 = 20
        self.angle_bras3 = 90 + self.angle_bras2
        self.anglemax3 = 330
        self.anglemin3 = 30
        
        
        #Détermination du second point (axe1) pour créer le bras 1
        #Le premier paramètre est la longueur du bras
        self.size_bras1 = (1, 0.1, 0.1)
        (a1,b1,c1) = self.size_bras1 
        (x0,y0,z0) = self.axe0
        self.axe1 = ( x0 + (float(a1))*math.cos(math.radians((float(self.angle_bras1))))   , y0 + (float(a1))* (math.sin(math.radians((float(self.angle_bras1))))) , z0)
        
        
        self.size_bras2 = (1, 0.1, 0.1) 
        (a2,b2,c2) = self.size_bras2 
        (x1,y1,z1) = self.axe1
        
        
        #Determination de l'axe2 pour créer le bras 2 suivant l'angle entre le bras 2 et le bras 1
        m = a1-a2
        n = a2
        xp = (n*x0 + m*x1) / (n+m)
        yp = (n*y0 + m*y1) / (n+m)
        X2 = (xp-x1) * math.cos(math.radians((float(self.angle_bras2)))) - (yp-y1) * math.sin(math.radians((float(self.angle_bras2)))) +x1
        Y2 = (xp-x1) * math.sin(math.radians(float(self.angle_bras2))) + (yp-y1) * math.cos(math.radians(float(self.angle_bras2))) +y1
        
        self.axe2 = ( X2, Y2 , z1)

        
        
        self.size_bras3 = (0.5, 0.1, 0.1) 
        (a3,b3,c3) = self.size_bras3  
        (x2,y2,z2) = self.axe2
        
        
        #Determination de l'axe3 pour créer le bras 3 suivant l'angle entre le bras 3 et le bras 2
        m = a2-a3
        n = a3
        xp = (n*x1 + m*x2) / (n+m)
        yp = (n*y1 + m*y2) / (n+m)
        X3 = (xp-x2) * math.cos(math.radians((float(-self.angle_bras3)))) - (yp-y2) * math.sin(math.radians((float(-self.angle_bras3)))) +x2
        Y3 = (xp-x2) * math.sin(math.radians(float(-self.angle_bras3))) + (yp-y2) * math.cos(math.radians(float(-self.angle_bras3))) +y2
        
        self.axe3 = ( X3  , Y3 , z2)
        
        (x3,y3,z3) = self.axe3
        
             
                
        self.dessin_robot = Dessin(self,self.scene_robot)
        self.dessin_camera = Dessin(self,self.scene_camera)
        self.trajectoire = []
        
        #X = (x2-(x0-2)) * math.cos(math.radians((float(180)))) - (y2-y0) * math.sin(math.radians((float(180)))) +(x0-2)
        #Y = (x2-(x0-2)) * math.sin(math.radians(float(180))) + (y2-y0) * math.cos(math.radians(float(180))) +y0
        X = x1+1.5
        Y = y1
        
        #L'objet que le robot doit attraper
        self.objectif = sphere(pos=(X,Y,z2), radius=0.05, color = color.yellow)
        self.objet_capture = 0
        
        #Coordonnées ou le robot doit amener l'objet une fois ramassé
        self.retour = sphere(pos=(x1+1,y1+a1-0.2,z1), radius=0.05, color = color.green, opacity = 0.5)
        
        
        #Test d'alignement sur Z
        #self.decale = sphere(pos=(x1,y1+a1/2,3), radius=0.05, color = color.black, opacity = 0.5)
        
        
            
        c = controls(title='Controlling the Scene',x=1200, y=0, width=500, height=500, range=130) # Create controls window
        # Create a slider in the controls window:
        s1 = slider(pos=(-15,-40),min=self.anglemin1,max=self.anglemax1, width=7, length=70, axis=(1,0,0),value =self.angle_bras1, action=lambda: self.update_bras1(s1,self.angle_bras1))
        s2 = slider(pos=(-15,-50),min=self.anglemin2,max=self.anglemax2, width=7, length=70, axis=(1,0,0),value =self.angle_bras2, action=lambda: self.update_bras2(s2,self.angle_bras2))
        s3 = slider(pos=(-15,-60),min=self.anglemin3,max=self.anglemax3, width=7, length=70, axis=(1,0,0),value =self.angle_bras3, action=lambda: self.update_bras3(s3,self.angle_bras3))
        s4 = slider(pos=(-15,-70),min=self.angleminZ,max=self.anglemaxZ, width=7, length=70, axis=(1,0,0),value =self.angle_Z, action=lambda: self.update_Z(s4,self.angle_Z))
        #s4 = slider(pos=(-15,-80),min=-5,max=5, width=7, length=70, axis=(1,0,0),value =x2,range = 100000, action=lambda: move_robot_cercle(s4))
        b = button( pos=(-20,10), width=80, height=80, text='Suivre une trajectoire', action=lambda: self.suivre_trajectoire(self.trajectoire) )
        b1 = button( pos=(65,10), width=80, height=80, text='Récupérer lobjet', action=lambda: self.chercher_objet() )
        #b2 = button( pos=(65,10+85), width=80, height=80, text='Saligner sur Z', action=lambda: self.aligner_sur_Z(self.decale.pos) )
        
       
    def update_bras1(self,obj,val): # Called by controls when slider1 is moved

        #self.angle_bras1 = obj.value
        angle = obj.value - val
        self.deplacer_bras1(angle)
           
    def deplacer_bras1(self,angle): # Deplacer le bras 1 suivant  un angle donné, les autres bras suivent en conséquence
          
   
        self.angle_bras1 = self.angle_bras1 + angle

        delta =  angle
        
        anglez = self.angle_Z
        self.rotationZ(-(self.angle_Z))
        
        (x0,y0,z0) = self.axe0
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
      
      
        X1 = (x1-x0) * math.cos(math.radians((float(delta)))) - (y1-y0) * math.sin(math.radians((float(delta)))) +x0
        Y1 = (x1-x0) * math.sin(math.radians(float(delta))) + (y1-y0) * math.cos(math.radians(float(delta))) +y0
        #Z1 =  X1 * tan(math.radians(self.angle_Z)) 
        X2 = (x2-x0) * math.cos(math.radians((float(delta)))) - (y2-y0) * math.sin(math.radians((float(delta)))) +x0
        Y2 = (x2-x0) * math.sin(math.radians(float(delta))) + (y2-y0) * math.cos(math.radians(float(delta))) +y0
        #Z2 = X2 * tan(math.radians(self.angle_Z)) 
        #X3 = (x3-x0) * math.cos(math.radians((float(delta)))) - (y3-y0) * math.sin(math.radians((float(delta)))) +x0
        #Y3 = (x3-x0) * math.sin(math.radians(float(delta))) + (y3-y0) * math.cos(math.radians(float(delta))) +y0
        
        self.axe1 = (X1,Y1,z1)
        self.axe2 = (X2,Y2,z2)
        #self.axe3 = (X3,Y3,z3)
          
          
        (u,v,w) = (X2-x2,Y2-y2,z2-z2)
          
        self.axe3 = (x3+u,y3+v,z3+w)
      
        self.rotationZ(anglez) 
        #self.angleAxe3 = self.angleAxe3 + angle
        #pince1.rotate(angle=radians(angle), axis=(0,0,1), origin=pince1.pos)
        self.update_all()
          

    def update_bras2(self,obj,val): # Called by controls when slider1 is moved

        #self.angle_bras2 = obj.value
        angle =obj.value - val 
        self.deplacer_bras2(angle)
          
          
    def deplacer_bras2(self,angle):
        self.angle_bras2 = self.angle_bras2 + angle
        delta = angle
        anglez = self.angle_Z
        self.rotationZ(-(self.angle_Z))
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
          
        X2 = (x2-x1) * math.cos(math.radians((float(delta)))) - (y2-y1) * math.sin(math.radians((float(delta)))) +x1
        Y2 = (x2-x1) * math.sin(math.radians(float(delta))) + (y2-y1) * math.cos(math.radians(float(delta))) +y1
 
        #X3 = (x3-x1) * math.cos(math.radians((float(delta)))) - (y3-y1) * math.sin(math.radians((float(delta)))) +x1
        #Y3 = (x3-x1) * math.sin(math.radians(float(delta))) + (y3-y1) * math.cos(math.radians(float(delta))) +y1
         
        self.axe2 = (X2,Y2,z2)
        #self.axe3 = (X3,Y3,z3)
         
        (u,v,w) = (X2-x2,Y2-y2,z2-z2)
              
        self.axe3 = (x3+u,y3+v,z3+w)
        self.rotationZ(anglez)  
          
        #self.angleAxe3 = self.angleAxe3 + angle
        #pince1.rotate(angle=radians(angle), axis=(0,0,1), origin=pince1.pos)
        self.update_all()
          
          
          
    def update_bras3(self,obj,val): # Called by controls when slider1 is moved
        angle =obj.value - val 
        self.deplacer_bras3(angle)
         
      
    def deplacer_bras3(self,angle):
        self.angle_bras3 = self.angle_bras3 + angle
        delta = angle
        anglez = self.angle_Z
        self.rotationZ(-(self.angle_Z))
        

        (x0,y0,z0) = self.axe0
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
        
        X3 = (x3-x2) * math.cos(math.radians((float(delta)))) - (y3-y2) * math.sin(math.radians((float(delta)))) +x2
        Y3 = (x3-x2) * math.sin(math.radians(float(delta))) + (y3-y2) * math.cos(math.radians(float(delta))) +y2
        
        self.axe3 = (X3,Y3,z3)
        
        
        
        
        
        
        
        
        
        
        

        self.dessin_robot.angleAxe3 = self.dessin_robot.angleAxe3 + angle
        self.dessin_robot.pince1.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_robot.pince1.pos)
        self.dessin_robot.pince2.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_robot.pince2.pos)
        self.dessin_robot.pince3.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_robot.pince3.pos)
        
        self.dessin_camera.angleAxe3 = self.dessin_robot.angleAxe3 + angle
        self.dessin_camera.pince1.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_camera.pince1.pos)
        self.dessin_camera.pince2.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_camera.pince2.pos)
        self.dessin_camera.pince3.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_camera.pince3.pos)
        
        self.dessin_camera.socle_camera.rotate(angle=radians(angle), axis=(0,0,1), origin=self.dessin_camera.socle_camera.pos)

        
        
        
        self.dessin_camera.champs_vision.pos = self.dessin_camera.camera.pos
        
        
        #self.dessin_camera.champs_vision.rotate(angle=radians(180),axis=(0,0,1),origin=(x+a/2.0,y,z))
        self.dessin_camera.champs_vision.rotate(angle=radians(angle),axis=(0,0,1),origin=self.dessin_camera.champs_vision.pos)
        self.rotationZ(anglez)
        self.update_all()
    
    def update_Z(self,obj,val): # Called by controls when slider1 is moved
        angle =obj.value - val 
        self.rotationZ(angle)
    
    
      
    def rotationZ(self,angle):
        
        self.angle_Z = self.angle_Z + angle

        delta =  angle

        (x0,y0,z0) = self.axe0
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
      
      
        X1 = (x1-x0) * math.cos(math.radians((float(delta)))) - (z1-z0) * math.sin(math.radians((float(delta)))) +x0
        Z1 = (x1-x0) * math.sin(math.radians(float(delta))) + (z1-z0) * math.cos(math.radians(float(delta))) +z0
      
        X2 = (x2-x0) * math.cos(math.radians((float(delta)))) - (z2-z0) * math.sin(math.radians((float(delta)))) +x0
        Z2 = (x2-x0) * math.sin(math.radians(float(delta))) + (z2-z0) * math.cos(math.radians(float(delta))) +z0
      
      
        X3 = (x3-x0) * math.cos(math.radians((float(delta)))) - (z3-z0) * math.sin(math.radians((float(delta)))) +x0
        Z3 = (x3-x0) * math.sin(math.radians(float(delta))) + (z3-z0) * math.cos(math.radians(float(delta))) +z0
        
        
        
        self.axe1 = (X1,y1,Z1)
        self.axe2 = (X2,y2,Z2)
        self.axe3 = (X3,y3,Z3)
     
        
        #print(360-self.angle_Z)  
          
        self.dessin_robot.bras1.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_robot.bras1.pos)
        
        self.dessin_robot.rotorA.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.axe0)
        self.dessin_robot.rotorB.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.axe0)
        
        self.dessin_robot.pince1.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_robot.pince1.pos)
        self.dessin_robot.pince2.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_robot.pince2.pos)
        self.dessin_robot.pince3.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_robot.pince3.pos)
        

        self.dessin_camera.pince1.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_camera.pince1.pos)
        self.dessin_camera.pince2.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_camera.pince2.pos)
        self.dessin_camera.pince3.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_camera.pince3.pos)
        
        self.dessin_camera.socle_camera.rotate(angle=radians(-angle), axis=(0,1,0), origin=self.dessin_camera.socle_camera.pos)

        
        
        
        self.dessin_camera.champs_vision.pos = self.dessin_camera.camera.pos
        
        
        #self.dessin_camera.champs_vision.rotate(angle=radians(180),axis=(0,0,1),origin=(x+a/2.0,y,z))
        
        
        self.dessin_camera.champs_vision.rotate(angle=radians(-angle),axis=(0,1,0),origin=self.dessin_camera.champs_vision.pos)
      
        
        #self.angleAxe3 = self.angleAxe3 + angle
        #pince1.rotate(angle=radians(angle), axis=(0,0,1), origin=pince1.pos)
        self.update_all()
        
        
        
        
        
        
        
        
        
          
          
    def update_all(self): # Met à jour graphiquement tous les objets suivant leur nouvelle position


        (x0,y0,z0) = self.axe0
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
     
      
        self.dessin_robot.bras1.pos = ( (x1+x0)/2 , (y1+y0)/2, (z1+z0)/2)
        self.dessin_robot.bras1.axis = (x1-x0,y1-y0,z1-z0)
        self.dessin_robot.bras2.pos = ( (x1+x2)/2 , (y1+y2)/2, (z1+z2)/2)      
        self.dessin_robot.bras2.axis = (x2-x1,y2-y1,z2-z1)
        self.dessin_robot.bras3.pos = ( (x2+x3)/2 , (y2+y3)/2, (z2+z3)/2)      
        self.dessin_robot.bras3.axis = (x3-x2,y3-y2,z3-z2)
        self.dessin_robot.articulation.pos = self.axe1
        self.dessin_robot.articulation2.pos = self.axe2
        self.dessin_robot.pince1.pos=(x3+ (0.025) * cos(radians(self.dessin_robot.angleAxe3)),y3 + (0.025) * sin(radians(self.dessin_robot.angleAxe3)),z3)
        (xp2,yp2,zp2) = self.dessin_robot.pince2.pos
        (xp3,yp3,zp3) = self.dessin_robot.pince3.pos
        self.dessin_robot.pince2.pos=(x3+ (0.025) * cos(radians(self.dessin_robot.angleAxe3))+ (0.125)*sin(radians(self.angle_Z)),y3 + (0.025) * sin(radians(self.dessin_robot.angleAxe3)),z3 - (0.125)*cos(radians(self.angle_Z))+self.dessin_robot.pince1_deviation)
        self.dessin_robot.pince3.pos=(x3+ (0.025) * cos(radians(self.dessin_robot.angleAxe3))- (0.125)*sin(radians(self.angle_Z)),y3 + (0.025) * sin(radians(self.dessin_robot.angleAxe3)),z3 + (0.125)*cos(radians(self.angle_Z))-self.dessin_robot.pince2_deviation)
        
        
        self.dessin_camera.bras1.pos = ( (x1+x0)/2 , (y1+y0)/2, (z1+z0)/2)
        self.dessin_camera.bras1.axis = (x1-x0,y1-y0,z1-z0)
        self.dessin_camera.bras2.pos = ( (x1+x2)/2 , (y1+y2)/2, (z1+z2)/2)      
        self.dessin_camera.bras2.axis = (x2-x1,y2-y1,z2-z1)
        self.dessin_camera.bras3.pos = ( (x2+x3)/2 , (y2+y3)/2, (z2+z3)/2)      
        self.dessin_camera.bras3.axis = (x3-x2,y3-y2,z3-z2)
        self.dessin_camera.articulation.pos = self.axe1
        self.dessin_camera.pince1.pos=(x3+ (0.025) * cos(radians(self.dessin_robot.angleAxe3)),y3 + (0.025) * sin(radians(self.dessin_robot.angleAxe3)),z3)
        (xp2,yp2,zp2) = self.dessin_camera.pince2.pos
        (xp3,yp3,zp3) = self.dessin_camera.pince3.pos
        self.dessin_camera.pince2.pos=(x3+ (0.025) * cos(radians(self.dessin_camera.angleAxe3))+ (0.125)*sin(radians(self.angle_Z)),y3 + (0.025) * sin(radians(self.dessin_camera.angleAxe3)),z3 - (0.125)*cos(radians(self.angle_Z))+self.dessin_robot.pince1_deviation)
        self.dessin_camera.pince3.pos=(x3+ (0.025) * cos(radians(self.dessin_robot.angleAxe3))- (0.125)*sin(radians(self.angle_Z)),y3 + (0.025) * sin(radians(self.dessin_robot.angleAxe3)),z3 + (0.125)*cos(radians(self.angle_Z))- self.dessin_robot.pince2_deviation)
        
        
        
        (a,b,c) = self.dessin_camera.socle_camera.size
        
        xcs = x3 - ((0.2) * cos(radians(self.dessin_robot.angleAxe3)) + (b/2)*sin(radians(self.dessin_robot.angleAxe3)))* cos(radians(self.angle_Z)) 
        ycs = y3 - (0.2) * sin(radians(self.dessin_robot.angleAxe3)) +(b/2)*cos(radians(self.dessin_robot.angleAxe3))   
        zcs = z3 - ((0.2) * cos(radians(self.dessin_robot.angleAxe3)) + (b/2)*sin(radians(self.dessin_robot.angleAxe3)))* sin(radians(self.angle_Z))
        
        self.dessin_camera.socle_camera.pos=(xcs ,ycs ,zcs)
        
        xc = x3 - ((0.2) * cos(radians(self.dessin_robot.angleAxe3)) + (b)*sin(radians(self.dessin_robot.angleAxe3)))* cos(radians(self.angle_Z)) 
        yc = y3 - (0.2) * sin(radians(self.dessin_robot.angleAxe3)) +(b)*cos(radians(self.dessin_robot.angleAxe3))   
        zc = z3 - ((0.2) * cos(radians(self.dessin_robot.angleAxe3)) + (b)*sin(radians(self.dessin_robot.angleAxe3)))* sin(radians(self.angle_Z))
        
        self.dessin_camera.camera.pos = (xc,yc,zc)
        (a,b,c) = self.dessin_camera.champs_vision.size
        
        (x,y,z) = self.dessin_camera.camera.pos
        
        xcv = x + ((a) * cos(radians(self.dessin_robot.angleAxe3)) * cos(radians(self.angle_Z))) 
        ycv = y + (a) * sin(radians(self.dessin_robot.angleAxe3))  
        zcv = z + ((a) * cos(radians(self.dessin_robot.angleAxe3)) * sin(radians(self.angle_Z)))
        
        
        self.dessin_camera.champs_vision.pos = (xcv ,ycv ,zcv)
        
        #self.dessin_camera.champs_vision.rotate(angle=radians(180),axis=(0,0,1),origin=(x+a/2.0,y,z))
        
        (ap,bp,cp) = self.dessin_robot.pince1.size
        
        r =self.objectif.radius+cp
        if(self.objet_capture):
            self.objectif.pos = (x3 + r * cos(radians(self.dessin_robot.angleAxe3)),y3 + r * sin(radians(self.dessin_robot.angleAxe3)),z3)
            

        
        
        
        
        
        
        
        
        
        
        
    drag_pos = None # no object picked yet
    drag_bool = 1
      
    draw_point = 0
      
      
    def grab(self,evt): # Appelé suite à un clic sur la zone graphique
        global drag_pos
        global drag_bool
        if evt.pick == self.dessin_robot.pince:
            drag_pos = evt.pickpos
            drag_bool = 1
            # Associe un évènement avec une fonction
            self.scene_robot.bind('mousemove', self.move, self.dessin.pince)
            self.scene_robot.bind('mouseup', self.drop)
        else:
            draw_point = 1
            self.scene_robot.bind('mousemove', self.draw)
            self.scene_robot.bind('mouseup', self.drop_drawing)
              
    def draw(self,evt): 
        (x1,y1,z1) = self.axe1
        (x,y,z) = self.scene_robot.mouse.pos
              
        points(display = self.scene_robot,pos=(x,y,z), size=10, color=color.red)
             
        self.trajectoire.append((x,y,z))
    
    def move(self,evt, obj):
        global drag_pos
        global drag_bool

          
        # project onto xy plane, even if scene rotated:
        new_pos = self.scene.mouse.pos
          
        
        if new_pos != drag_pos: # if mouse has moved 
            # Deplace l'objet suivant la nouvelle position du drag
            (xn,yn,zn) = new_pos - drag_pos
            (xo,yo,zo) = obj.pos  
            obj.pos = (xn+xo,yn+yo,zo)

            self.move_robot(obj.pos)
            drag_pos = new_pos # update drag position
      
      
    def drop(self,evt):
          
        self.scene_robot.unbind('mousemove', self.move)
        self.scene_robot.unbind('mouseup', self.drop)
      

    def drop_drawing(self,evt):
        self.scene_robot.unbind('mousemove', self.draw)
        self.scene_robot.unbind('mouseup', self.drop_drawing)
      
   
          
    def aligner_sur_Z(self,destination):
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
        (x0,y0,z0) = self.axe0
        (xd,yd,zd) = destination
        
       
        
            


            
        x = x3
        z = z3
        
        (u,v) = (x-x0,z-z0)
        
        (x,z) = (x+1000.0*u,z+1000.0*v)


        distanceCentreversDest = sqrt((xd-x0)**2 + (zd-z0)**2)
        (xr,zr) = (x0+distanceCentreversDest,z0)
          
       
        distanceRefversDest = sqrt((xd-xr)**2 + (zd-zr)**2)
        angleDest = 2.0 * math.degrees(math.asin((distanceRefversDest /2.0) / distanceCentreversDest ))
        if(zd<zr):
            angleDest = -angleDest
        
        
        distanceCentreversAxe1 = sqrt((x-x0)**2 + (z-z0)**2)  
        (xr1,zr1) = (x0+distanceCentreversAxe1,z0)  
        distanceRefversDepart = sqrt((x-xr1)**2 + (z-zr1)**2)
        

        print((distanceRefversDepart /2.0) / distanceCentreversAxe1  )

        
    
        angleInter = 2.0 * math.degrees(math.asin((distanceRefversDepart /2.0) / distanceCentreversAxe1 ))

        if(z<zr1):
            angleInter = -angleInter
          
        angleDest = angleDest - angleInter
        
#         if (angleDest>90.0):
#                 angleDest = ( angleDest - 180.0 )
#         
#         if (angleDest<(-90.0)):
#                 angleDest = ( angleDest + 180.0 )        
        
        if angleDest >= 0:
            j=1
             
        else:
            
            j=-1
        print(angleDest)      
        angleRetour = angleDest
        
        

        while (angleDest != 0):
            rate(50)
                              
            print(angleDest)
            if angleDest > 1.0 or angleDest < -1.0 :      
                self.rotationZ(j)
                angleDest = angleDest - j
            else:
                self.rotationZ(angleDest)    
                angleDest = 0
           
        return angleRetour  
    
    
    
    
    
    def move_robot(self,destination):
          
        
        
        (xd,yd,zd) = destination
        (x0,y0,z0) = self.axe0
        (a1,b1,c1) = self.size_bras1
        (a2,b2,c2) = self.size_bras2
        
        
        distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2 + (zd-z0)**2)
        if(distanceAxe0versDest > (a1+a2)):
            print("grand")
            return
        (x1,y1,z1) = self.axe1
        if(zd != z1):
            abcs = self.aligner_sur_Z(destination) 
        
        Xd = (xd-x0) * math.cos(math.radians((float(-self.angle_Z)))) - (zd-z0) * math.sin(math.radians((float(-self.angle_Z)))) +x0
        Zd = (xd-x0) * math.sin(math.radians(float(-self.angle_Z))) + (zd-z0) * math.cos(math.radians(float(-self.angle_Z))) +z0
        
        
        
        destination = (Xd,yd,Zd)
        
        
        angleRetour = self.angle_Z
       
        self.rotationZ(-self.angle_Z)
        
        
        
        (xd,yd,zd) = destination
        (x0,y0,z0) = self.axe0
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3  
        
          
        distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2)
        distanceAxe1versAxe2 = sqrt((x1-x2)**2 + (y1-y2)**2)
          
        # Si le robot peut atteindre l'objectif
        # On continue
        
          
        if(distanceAxe0versDest+distanceAxe1versAxe2 <a1):
            print("bizarre")
            return 
        if(y1 == y0): #Si les deux axes ont la meme hauteur, il y aura une division par zero donc on deplace de 0.1
            self.deplacer_bras1(0.1)
        
        (x1,y1,z1) = self.axe1
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3 
              
              
           
        # Calcul des points d'intersection entre les cercles de centre axe0 et de rayon ||Axe0,Destination || et de centre axe1 et de rayon la taille du bras 2

        ((xa,ya),(xb,yb)) = self.intersection_cercle(x0,y0,x1,y1,distanceAxe0versDest,distanceAxe1versAxe2)
          
        #distanceInterAversAxe2 = sqrt((x2-xa)**2 + (y2-ya)**2)
        #distanceInterBversAxe2 = sqrt((x2-xb)**2 + (y2-yb)**2)
          
        #if(distanceInterAversAxe2 <= distanceInterBversAxe2):
            #(xi,yi) = (xa,ya)
        #else:
            #(xi,yi) = (xb,yb)
          
        distanceInterAversAxed = sqrt((xd-xa)**2 + (yd-ya)**2)
        distanceInterBversAxed = sqrt((xd-xb)**2 + (yd-yb)**2)
          
        #On prend le point le plus proche de la destination
        if(distanceInterAversAxed <= distanceInterBversAxed):
            (xi,yi) = (xa,ya)
        else:
            (xi,yi) = (xb,yb)
          
          
          
          
              
#         (xr0,yr0) = (x0+distanceAxe0versDest,y0)
#           
#           
#         distanceRefversDest = sqrt((xd-xr0)**2 + (yd-yr0)**2)
#         angleDest = 2.0 * math.degrees(math.asin((distanceRefversDest /2) / distanceAxe0versDest ))
#         if(yd<yr0):
#             angleDest = -angleDest
#           
#           
#         distanceRefversInter = sqrt((xi-xr0)**2 + (yi-yr0)**2)
#         angleInter = 2.0 * math.degrees(math.asin((distanceRefversInter /2) / distanceAxe0versDest ))
#         if(yi<yr0):
#             angleInter = -angleInter
#           
#         angleDestVersInter = angleDest - angleInter
        
  
        angle1 = self.calculer_angle(self.axe0,(xa,ya,z1),destination)
        (X,Y,Z) = self.rotation_point(self.axe0, (x2,y2,z1), angle1)
        distancePointVersDest1 = sqrt((xd-X)**2 + (yd-Y)**2)
        
        angle2 = self.calculer_angle(self.axe0,(xb,yb,z1),destination)
        (X,Y,Z) = self.rotation_point(self.axe0, (x2,y2,z1), angle2)
        distancePointVersDest2 = sqrt((xd-X)**2 + (yd-Y)**2)
        
        
        if(distancePointVersDest1 <= distancePointVersDest2):
            angleDestVersInter = angle1
        else:
            angleDestVersInter = angle2
          
        
        
        if(self.angle_bras1+angleDestVersInter > self.anglemax1 or self.angle_bras1+angleDestVersInter < self.anglemin1 ):
            print("Angle max atteint")
            #return
          
          
          
        #On récupère seulement la nouvelle position de l'axe1 et axe2 qui sera modifier lors du déplacement, dans la prochaine boucle
          
        X1 = (x1-x0) * math.cos(math.radians((float(angleDestVersInter)))) - (y1-y0) * math.sin(math.radians((float(angleDestVersInter)))) +x0
        Y1 = (x1-x0) * math.sin(math.radians(float(angleDestVersInter))) + (y1-y0) * math.cos(math.radians(float(angleDestVersInter))) +y0
          
        X2 = (x2-x0) * math.cos(math.radians((float(angleDestVersInter)))) - (y2-y0) * math.sin(math.radians((float(angleDestVersInter)))) +x0
        Y2 = (x2-x0) * math.sin(math.radians(float(angleDestVersInter))) + (y2-y0) * math.cos(math.radians(float(angleDestVersInter))) +y0
          
        (x1,y1) = (X1,Y1)
        (x2,y2) = (X2,Y2)
          
          
          
        (xr1,yr1) = (x1+distanceAxe1versAxe2,y1)
          
          
          
             
        distanceRefversDest = sqrt((xd-xr1)**2 + (yd-yr1)**2)
        distanceAxe1versDest = sqrt((xd-x1)**2 + (yd-y1)**2)
        angleDest = 2 * math.degrees(math.asin((distanceRefversDest /2) / distanceAxe1versAxe2 ))
            #print((distanceRefversDest /2) / a2 )
        if(yd<yr1):
            angleDest = -angleDest
          
        distanceRefversAxe2 = sqrt((x2-xr1)**2 + (y2-yr1)**2)
        angleAxe2 = 2 * math.degrees(math.asin((distanceRefversAxe2 /2) / distanceAxe1versAxe2 ))
        if(y2<yr1):
            angleAxe2 = -angleAxe2
          
        angleAxe2VersDest = angleDest - angleAxe2 
          
          
        # if(self.angle_bras2+angleAxe2VersDest > self.anglemax2 or self.angle_bras2+angleAxe2VersDest < self.anglemin2 ):
        #    return
          
        #print(distanceAxe1versDest)
        #print(a2)
          
          
          
          
          
          
        if angleDestVersInter >= 0:
            i=1
        else:
            i=-1    
          
        if angleAxe2VersDest >= 0:
            j=1
        else:
            j=-1
              
          
        self.rotationZ(angleRetour)
        
        while (angleDestVersInter != 0 or angleAxe2VersDest != 0):
            rate(50)
            if angleDestVersInter > 1.0 or angleDestVersInter< -1.0:
                self.deplacer_bras1(i)
                angleDestVersInter = angleDestVersInter - i
            else:
               
                self.deplacer_bras1(angleDestVersInter)
                angleDestVersInter = 0
              

            if angleAxe2VersDest > 1.0 or angleAxe2VersDest < -1.0 :      
                self.deplacer_bras2(j)
                angleAxe2VersDest = angleAxe2VersDest - j
            else:
                self.deplacer_bras2(angleAxe2VersDest)    
                angleAxe2VersDest = 0
              
              
    def rotation_point(self,centre,depart,angle): 
        
        (xc,yc,zc) = centre
        (xi,yi,zi) = depart
        
        
        X = (xi-xc) * math.cos(math.radians((angle))) - (yi-yc) * math.sin(math.radians(angle)) +xc
        Y = (xi-xc) * math.sin(math.radians(angle)) + (yi-yc) * math.cos(math.radians(angle)) +yc 
      
        return (X,Y,zi)
        
    def calculer_angle(self,centre,depart,destination):
        
        (xc,yc,zc) = centre
        (xd,yd,zd) = destination
        (xi,yi,zi) = depart
        distanceCentreversDest = sqrt((xd-xc)**2 + (yd-yc)**2)
        (xr,yr) = (xc+distanceCentreversDest,yc)
          
       
        distanceRefversDest = sqrt((xd-xr)**2 + (yd-yr)**2)
        angleDest = 2.0 * math.degrees(math.asin((distanceRefversDest /2) / distanceCentreversDest ))
        if(yd<yr):
            angleDest = -angleDest
          
          
        distanceRefversDepart = sqrt((xi-xr)**2 + (yi-yr)**2)
        angleInter = 2.0 * math.degrees(math.asin((distanceRefversDepart /2) / distanceCentreversDest ))
        if(yi<yr):
            angleInter = -angleInter
          
        angleDestVersInter = angleDest - angleInter  
        
        return angleDestVersInter
      
    
    
    
    
    def chercher_objet(self):
        (a3,b3,c3) = self.size_bras3
        
        decalage = 2.0*a3
          
        (xo,yo,zo) = self.objectif.pos
        
        abcs = self.aligner_sur_Z(self.objectif.pos)
        (xr,yr,zr) = (xo+decalage,yo,zo)
          
        angle = 180.0
          
          
          
        xa = (xr-xo) * math.cos(math.radians((float(angle)))) - (yr-yo) * math.sin(math.radians((float(angle)))) +xo
        ya = (xr-xo) * math.sin(math.radians(float(angle))) + (yr-yo) * math.cos(math.radians(float(angle))) +yo
          
        #angle = 180-angle   
        xb = (xr-xo) * math.cos(math.radians((float(angle)))) - (yr-yo) * math.sin(math.radians((float(angle)))) +xo
        yb = (xr-xo) * math.sin(math.radians(float(angle))) + (yr-yo) * math.cos(math.radians(float(angle))) +yo    
          
        (x2,y2,z2) = self.axe2
          
        distancePointAversAxe2= sqrt((x2-xa)**2 + (y2-ya)**2)
        distancePointBversAxe2 = sqrt((x2-xb)**2 + (y2-yb)**2)
          
        if(distancePointAversAxe2 <= distancePointBversAxe2):
            destination = (xa,ya,zo)
           
            
        else:
            destination = (xb,yb,zo)
            
            
       
         
       
        chemin = self.creer_trajectoire(self.axe2,destination)
  
        self.suivre_trajectoire(chemin)
        #self.move_robot(destination)
          
         
          
        (x2,y2,z2) = self.axe2
        (x3,y3,z3) = self.axe3
          
        (xr2,yr2) = (x2+decalage,y2)
          
          
        
        distanceRefversObjectif = sqrt((xo-xr2)**2 + (yo-yr2)**2)
        distanceAxe2versObjectif = sqrt((xo-x2)**2 + (yo-y2)**2)
          
          
        angleObjectif = 2 * math.degrees(math.asin((distanceRefversObjectif /2.0) / distanceAxe2versObjectif ))
        #print((distanceRefversDest /2) / a2 )
        if(yo<yr2):
            angleObjectif = -angleObjectif
          
          
        (u,v,w) = ((x3-x2),(y3-y2),(z3-z2))
          
        (x3_bis,y3_bis,z3_bis) = (x3+u,y3+v,z3+w)
        
        
        
        
        
        
        
        
        distanceRefversAxe3 = sqrt((x3_bis-xr2)**2 + (y3_bis-yr2)**2)
        angleAxe3 = 2 * math.degrees(math.asin((distanceRefversAxe3 /2.0) / (decalage) ))
        if(y3_bis<yr2):
            angleAxe3 = -angleAxe3
          
        angleAxe3VersObjectif = angleObjectif - angleAxe3
          
        if angleAxe3VersObjectif >= 0:
            j=1
        else:
            j=-1
              

        while (angleAxe3VersObjectif != 0):
            rate(49)
                              

            if angleAxe3VersObjectif > 1.0 or angleAxe3VersObjectif < -1.0 :      
                self.deplacer_bras3(j)
                angleAxe3VersObjectif = angleAxe3VersObjectif - j
            else:
                self.deplacer_bras3(angleAxe3VersObjectif)    
                angleAxe3VersObjectif = 0
        
        (x3,y3,z3) = self.axe3
        (u,v) = ((x3-xo),(y3-yo))
        
        (ap,bp,cp) = self.dessin_robot.pince1.size
              
        r =2*self.objectif.radius+cp+0.03

        (xo,yo,zo) = (xo+r*u,yo+r*v,zo)      
        points(display = self.scene_robot,pos=(xo,yo,zo), size=10, color=color.red)
        
        
        (u,v,w) = (xo-x3,yo-y3,zo-z3)
        (x2,y2,z2) = self.axe2 
        chemin2 = self.creer_trajectoire(self.axe2,(x2 + u,y2 + v,z2 + w))
        self.suivre_trajectoire(chemin2) 
        #self.move_robot((x2 + u,y2 + v,z2 + w))    
        
        
        self.serrer_pinces()
        self.objet_capture =1
        
        (xr,yr,zr) = self.retour.pos
        
        chemin3 = self.creer_trajectoire(self.axe2,(xr - a3,yr,zr))
        self.suivre_trajectoire(chemin3)
        
        
        angleAxe3Retour = self.calculer_angle(self.axe2,self.axe3,self.retour.pos)
        
        
        if angleAxe3Retour >= 0:
            j=1
        else:
            j=-1
              

        while (angleAxe3Retour != 0):
            rate(49)
                              

            if angleAxe3Retour > 1.0 or angleAxe3Retour < -1.0 :      
                self.deplacer_bras3(j)
                angleAxe3Retour = angleAxe3Retour - j
            else:
                self.deplacer_bras3(angleAxe3VersObjectif)    
                angleAxe3Retour = 0
        
        self.deserrer_pinces()
        
        
    def intersection_cercle(self,x0,y0,x1,y1,a1,a2):  #Fonction qui retourne les points d'intersections de deux cercles
        
       
       
        N = (a2**2 - a1**2 - x1**2 + x0**2 - y1**2 + y0**2)/(2*(y0-y1)) 
       
        A = ((x0-x1)/(y0-y1))**2 + 1
       
        B = 2*y0*(x0-x1)/(y0-y1) - 2*N*(x0-x1)/(y0-y1) - 2*x0
       
        C = x0**2 + y0**2 + N**2 - a1**2 - 2*y0*N
       
        delta = sqrt(B**2 - 4*A*C)
  
        xa = (-B + delta)/(2*A)
        ya = N - xa *(x0-x1)/(y0-y1)

        xb = (-B - delta)/(2*A)
        yb = N - xb *(x0-x1)/(y0-y1)
       
        Xa = (xa,ya)
        Xb = (xb,yb) 
        return (Xa,Xb)
        
    
    
    def suivre_trajectoire(self,chemin):
            
            for destination in chemin:
                #rate(15)
                print("FINI") 
                self.move_robot(destination)
        
            
    
    def creer_trajectoire(self,depart,destination):    
        
        distance_entre_points = (1.0/100.0)
        print(distance_entre_points)
        pointList = []
       
        (xa,ya,za) = depart
        (xb,yb,zb) = destination
        
        distanceAversB = sqrt((xa-xb)**2 + (ya-yb)**2)
  
        nb_point = (distanceAversB * (1/distance_entre_points))
        
  
        (u,v,w) = (xb-xa,yb-ya,zb-za)   
        

        delta = 1/nb_point
        
  
        i=1.0
        while (nb_point != 0):                 

            if nb_point > 1.0 :      
                (x,y,z) = (xa+i*delta*u,ya+i*delta*v,za+i*delta*w)
                nb_point = nb_point - 1.0
                pointList.append((x,y,z))
                points(display = self.scene_robot,pos=(x,y,z), size=10, color=color.green)
            else:
                pointList.append(destination)   
                nb_point = 0
        
            i = i+1.0
        return pointList
        
        
  
    def serrer_pinces(self):
        
        (xo,yo,zo) = self.objectif.pos
        
        zmax_pince2 = 0.07
        
        zmax_pince3 = 0.07
        
        (xp2,yp2,zp2) = self.dessin_robot.pince2.pos
        (xp3,yp3,zp3) = self.dessin_robot.pince3.pos
        
        while( self.dessin_robot.pince1_deviation < zmax_pince2 and self.dessin_robot.pince2_deviation < zmax_pince3  ):
            rate(49)
            self.dessin_robot.pince1_deviation = self.dessin_robot.pince1_deviation + 0.001
            self.dessin_robot.pince2_deviation = self.dessin_robot.pince2_deviation + 0.001
            
            self.update_all()
  
    def deserrer_pinces(self):
        
        (xo,yo,zo) = self.objectif.pos
        
        zmax_pince2 = zo-self.objectif.radius
        
        zmax_pince3 = zo+self.objectif.radius
        
        (xp2,yp2,zp2) = self.dessin_robot.pince2.pos
        (xp3,yp3,zp3) = self.dessin_robot.pince3.pos
        
        (x3,y3,z3) = self.axe3
        
        while( self.dessin_robot.pince1_deviation > 0 and self.dessin_robot.pince2_deviation > 0  ):
            rate(49)
            self.dessin_robot.pince1_deviation = self.dessin_robot.pince1_deviation - 0.001
            self.dessin_robot.pince2_deviation = self.dessin_robot.pince2_deviation - 0.001
            self.update_all()
            self.objet_capture = 0
             
             
            
