# -*- coding: utf-8 -*-
'''
Created on 15 f�vr. 2014

@author: Adam
'''
from visual import *
from visual.controls import *
import math


class Interface3d():
    def __init__(self):
        scene = display(title='Bras Robotique', x=0, y=0, width=800, height=500, center=(2,0,3), background=(1,1,1))
        
        #Determination du point du centre du socle et du premier axe
        self.axe0 = (1,-1,2)
        
        #Dessin du socle
        socle = cylinder(pos=self.axe0, axis=(0,-0.2,0), radius=0.3,color = color.gray(0.7))
        
        #Dessin des deux rotor sur le socle
        rotorA = box (pos=(1,-0.9,1.9),size = (0.3,0.1,0.1),axis=(0,1,0), color = color.gray(0.7))
        rotorB = box (pos=(1,-0.9,2.1),size = (0.3,0.1,0.1),axis=(0,1,0), color = color.gray(0.7))        
        
        #Determination des angles min, max et courant de chaque bras du robot
        self.angle_bras1 =30
        self.anglemax1 = 135
        self.anglemin1 = 30
        self.angle_bras2 = 50
        self.anglemax2 = 190
        self.anglemin2 = 20
        self.angle_bras3 = 30
        self.anglemax3 = 330
        self.anglemin3 = 30
        
        #Détermination du second point (axe1) pour créer le bras 1
        #Le premier paramètre est la longueur du bras
        size_bras1 = (1, 0.1, 0.1)
        (a1,b1,c1) = size_bras1 
        (x0,y0,z0) = self.axe0
        self.axe1 = ( x0 + (float(a1))*math.cos(math.radians((float(self.angle_bras1))))   , y0 + (float(a1))* (math.sin(math.radians((float(self.angle_bras1))))) , z0)
        
        
        size_bras2 = (1, 0.1, 0.1) 
        (a2,b2,c2) = size_bras2 
        (x1,y1,z1) = self.axe1
        
        
        #Determination de l'axe2 pour créer le bras 2 suivant l'angle entre le bras 2 et le bras 1
        m = a1-a2
        n = a2
        xp = (n*x0 + m*x1) / (n+m)
        yp = (n*y0 + m*y1) / (n+m)
        X2 = (xp-x1) * math.cos(math.radians((float(self.angle_bras2)))) - (yp-y1) * math.sin(math.radians((float(self.angle_bras2)))) +x1
        Y2 = (xp-x1) * math.sin(math.radians(float(self.angle_bras2))) + (yp-y1) * math.cos(math.radians(float(self.angle_bras2))) +y1
        
        self.axe2 = ( X2, Y2 , z1)

        
        
        size_bras3 = (0.5, 0.1, 0.1) 
        (a3,b3,c3) = size_bras3  
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
        
        
         #Création des trois bras, de l'objectif à atteindre et des articulations
        pos_bras1 = ( (x1+x0)/2 , (y1+y0)/2, z1)
        bras1 = box (pos=pos_bras1, size=size_bras1, axis = (x1-x0,y1-y0,z1-z0),  color = color.red)
        
        pos_bras2 = ( (x1+x2)/2 , (y1+y2)/2, z2)      
        bras2 = box (pos=pos_bras2, size=size_bras2, axis = (x2-x1,y2-y1,z2-z1),  color = color.blue)
        
        pos_bras3 = ( (x2+x3)/2 , (y2+y3)/2, z3)      
        bras3 = box (pos=pos_bras3, size=size_bras3, axis = (x3-x2,y3-y2,z3-z2),  color = color.green)
        
        articulation = sphere(pos=self.axe1, radius=0.1)
        
        
        pince = sphere(pos=self.axe2, radius=0.1)
        
        X = (x2-(x0-2)) * math.cos(math.radians((float(60)))) - (y2-y0) * math.sin(math.radians((float(60)))) +(x0-2)
        Y = (x2-(x0-2)) * math.sin(math.radians(float(60))) + (y2-y0) * math.cos(math.radians(float(60))) +y0
        
        objectif = sphere(pos=(X,Y,z2), radius=0.1, color = color.yellow)
        
            
        c = controls() # Create controls window
        # Create a slider in the controls window:
        
        
        s1 = slider(pos=(-15,-40),min=self.anglemin1,max=self.anglemax1, width=7, length=70, axis=(1,0,0),value =self.angle_bras1, action=lambda: update_bras1(s1,self.angle_bras1))
        
        s2 = slider(pos=(-15,-50),min=self.anglemin2,max=self.anglemax2, width=7, length=70, axis=(1,0,0),value =self.angle_bras2, action=lambda: update_bras2(s2,self.angle_bras2))
        
        s3 = slider(pos=(-15,-60),min=self.anglemin3,max=self.anglemax3, width=7, length=70, axis=(1,0,0),value =self.angle_bras3, action=lambda: update_bras3(s3,self.angle_bras3))
        
        #s4 = slider(pos=(-15,-80),min=-5,max=5, width=7, length=70, axis=(1,0,0),value =x2,range = 100000, action=lambda: move_robot_cercle(s4))
        b = button( pos=(0,0), width=60, height=60, text='Click me', action=lambda: change() )
        
        def change():
            
            trajectoire()
        
        def update_bras1(obj,val): # Called by controls when slider1 is moved

            
       
            
            #self.angle_bras1 = obj.value
            angle = obj.value - val
            deplacer_bras1(angle)
            
        def deplacer_bras1(angle): # Deplacer le bras 1 suivant  un angle donné, les autres bras suivent en conséquence
            
            
            self.angle_bras1 = self.angle_bras1 + angle
  
            delta =  angle

            (x0,y0,z0) = self.axe0
            (x1,y1,z1) = self.axe1
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            
            X1 = (x1-x0) * math.cos(math.radians((float(delta)))) - (y1-y0) * math.sin(math.radians((float(delta)))) +x0
            Y1 = (x1-x0) * math.sin(math.radians(float(delta))) + (y1-y0) * math.cos(math.radians(float(delta))) +y0
            
            X2 = (x2-x0) * math.cos(math.radians((float(delta)))) - (y2-y0) * math.sin(math.radians((float(delta)))) +x0
            Y2 = (x2-x0) * math.sin(math.radians(float(delta))) + (y2-y0) * math.cos(math.radians(float(delta))) +y0
            
            X3 = (x3-x0) * math.cos(math.radians((float(delta)))) - (y3-y0) * math.sin(math.radians((float(delta)))) +x0
            Y3 = (x3-x0) * math.sin(math.radians(float(delta))) + (y3-y0) * math.cos(math.radians(float(delta))) +y0
          
            self.axe1 = (X1,Y1,z1)
            self.axe2 = (X2,Y2,z2)
            self.axe3 = (X3,Y3,z3)
            
            update_all()
            

        def update_bras2(obj,val): # Called by controls when slider1 is moved

            #self.angle_bras2 = obj.value
            angle =obj.value - val 
            deplacer_bras2(angle)
            
            
        def deplacer_bras2(angle):
            self.angle_bras2 = self.angle_bras2 + angle
            delta = angle
    
            (x1,y1,z1) = self.axe1
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            X2 = (x2-x1) * math.cos(math.radians((float(delta)))) - (y2-y1) * math.sin(math.radians((float(delta)))) +x1
            Y2 = (x2-x1) * math.sin(math.radians(float(delta))) + (y2-y1) * math.cos(math.radians(float(delta))) +y1
            
            X3 = (x3-x1) * math.cos(math.radians((float(delta)))) - (y3-y1) * math.sin(math.radians((float(delta)))) +x1
            Y3 = (x3-x1) * math.sin(math.radians(float(delta))) + (y3-y1) * math.cos(math.radians(float(delta))) +y1
            
            self.axe2 = (X2,Y2,z2)
            self.axe3 = (X3,Y3,z3)
            
            update_all()
            
            
            
        def update_bras3(obj,val): # Called by controls when slider1 is moved

            self.angle_bras3 = obj.value
            delta = val - obj.value

 
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            
            X3 = (x3-x2) * math.cos(math.radians((float(delta)))) - (y3-y2) * math.sin(math.radians((float(delta)))) +x2
            Y3 = (x3-x2) * math.sin(math.radians(float(delta))) + (y3-y2) * math.cos(math.radians(float(delta))) +y2
            
            self.axe3 = (X3,Y3,z3)
            
            update_all()
            
            
        def update_all(): # Met à jour graphiquement tous les objets suivant leur nouvelle position


            (x0,y0,z0) = self.axe0
            (x1,y1,z1) = self.axe1
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            
            bras1.pos = ( (x1+x0)/2 , (y1+y0)/2, z1)
            bras1.axis = (x1-x0,y1-y0,z1-z0)
            
            bras2.pos = ( (x1+x2)/2 , (y1+y2)/2, z2)      
            bras2.axis = (x2-x1,y2-y1,z2-z1)
            
            bras3.pos = ( (x2+x3)/2 , (y2+y3)/2, z3)      
            bras3.axis = (x3-x2,y3-y2,z3-z2)
            
            articulation.pos = self.axe1
    
            
        
        drag_pos = None # no object picked yet
        drag_bool = 1
        
        
        
        def grab(evt): # Appelé suite à un clic sur la zone graphique
            global drag_pos
            global drag_bool
            if evt.pick == pince:
                drag_pos = evt.pickpos
                drag_bool = 1
                # Associe un évènement avec une fonction
                scene.bind('mousemove', move, pince)
                scene.bind('mouseup', drop)
        
        def move(evt, obj):
            global drag_pos
            global drag_bool

            
            # project onto xy plane, even if scene rotated:
            new_pos = scene.mouse.pos

            if new_pos != drag_pos: # if mouse has moved
               
                # Deplace l'objet suivant la nouvelle position du drag
                (xn,yn,zn) = new_pos - drag_pos
                (xo,yo,zo) = obj.pos  
                obj.pos = (xn+xo,yn+yo,zo)
                
                
                (xd,yd,zd) = obj.pos
                (x0,y0,z0) = self.axe0
                (a1,b1,c1) = size_bras1
                (a2,b2,c2) = size_bras2
                # Calcul des distances entre axe0 et l'objectif, entre Axe0 et Axe1
                distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2)
                distanceAxe0versAxe1 = sqrt((x1-x2)**2 + (y1-y2)**2)
                
                if(distanceAxe0versDest <= (a1+a2)): # Si le robot peut atteindre l'objectif
                    # On deplace le robot vers cet objetctif
                    drag_bool = move_robot(obj.pos)
                else:
                    print("grand")
                drag_pos = new_pos # update drag position
        
        def drop(evt):
            scene.unbind('mousemove', move)
            scene.unbind('mouseup', drop)
        
        scene.bind('mousedown', grab)
        
        
        
        
        def move_robot(destination):
            
           
            (xd,yd,zd) = destination
            (x0,y0,z0) = self.axe0
            (x1,y1,z1) = self.axe1
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            (a1,b1,c1) = size_bras1
            (a2,b2,c2) = size_bras2
            
            
            distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2)
            if(distanceAxe0versDest+a2 <a1):
                return 
            if(y1 == y0): #Si les deux axes ont la meme hauteur, il y aura une division par zero donc on deplace de 0.1
                deplacer_bras1(0.1)
                (x1,y1,z1) = self.axe1
                (x2,y2,z2) = self.axe2
                (x3,y3,z3) = self.axe3 
                
                
             
            # Calcul des points d'intersection entre les cercles de centre axe0 et de rayon ||Axe0,Destination || et de centre axe1 et de rayon la taille du bras 2
 
            ((xa,ya),(xb,yb)) = self.intersection_cercle(x0,y0,x1,y1,distanceAxe0versDest,a2)
            
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
            
            
            
            
                
            (xr0,yr0) = (x0+distanceAxe0versDest,y0)
            
            
            distanceRefversDest = sqrt((xd-xr0)**2 + (yd-yr0)**2)
            angleDest = 2 * math.degrees(math.asin((distanceRefversDest /2) / distanceAxe0versDest ))
            if(yd<yr0):
                angleDest = -angleDest
            
            
            distanceRefversInter = sqrt((xi-xr0)**2 + (yi-yr0)**2)
            angleInter = 2 * math.degrees(math.asin((distanceRefversInter /2) / distanceAxe0versDest ))
            if(yi<yr0):
                angleInter = -angleInter
            
            angleDestVersInter = angleDest - angleInter

            
            if(self.angle_bras1+angleDestVersInter > self.anglemax1 or self.angle_bras1+angleDestVersInter < self.anglemin1 ):
                return
            deplacer_bras1(angleDestVersInter)
            
            
            
            
            
            (xr1,yr1) = (x1+a2,y1)
            
            
            if(yd == yr1):
                angleDest = 180.0
            else:    
                distanceRefversDest = sqrt((xd-xr1)**2 + (yd-yr1)**2)
                print((distanceRefversDest /2) / a2 )
                angleDest = 2 * math.degrees(math.asin((distanceRefversDest /2) / a2 ))
            
            if(yd<yr1):
                angleDest = -angleDest
            
            distanceRefversAxe2 = sqrt((x2-xr1)**2 + (y2-yr1)**2)
            angleAxe2 = 2 * math.degrees(math.asin((distanceRefversAxe2 /2) / a2 ))
            if(y2<yr1):
                angleAxe2 = -angleAxe2
            
            angleAxe2VersDest = angleDest - angleAxe2 
            
            
            # if(self.angle_bras2+angleAxe2VersDest > self.anglemax2 or self.angle_bras2+angleAxe2VersDest < self.anglemin2 ):
            #    return
            
            deplacer_bras2(angleAxe2VersDest)
        
            
            return 1
        
        
        
        
        def trajectoire():  # On bouge le robot suivant une suite de points
            
            destination = self.axe2
            angle_trajectoire = 0.1 

            (xd,yd,zd) = destination
            (x0,y0,z0) = self.axe0
            
            
            centre = self.axe0
            (xc,yc,zc) = (x0-2,y0,z0)
            cpt = 1
            
            while cpt<900:
                #200 animations par seconde
                rate(200)
                (xd,yd,zd) = destination
                
                X = (xd-xc) * math.cos(math.radians((float(angle_trajectoire)))) - (yd-yc) * math.sin(math.radians((float(angle_trajectoire)))) +xc
                Y = (xd-xc) * math.sin(math.radians(float(angle_trajectoire))) + (yd-yc) * math.cos(math.radians(float(angle_trajectoire))) +yc
            
                destination = (X,Y,zd)
                move_robot(destination) 
                cpt = cpt + 1
        
        
                
                
                
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
        
    
        
        
        
        
        
        
                
            
