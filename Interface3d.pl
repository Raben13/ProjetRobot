# -*- coding: utf-8 -*-
'''
Created on 1 f�vr. 2014
 
@author: Adam
'''
from visual import *
from visual.controls import *
import math
 
 
class Interface3d():
    def __init__(self):
        self.axe0 = (0,-1,1)
        
        rotor = cylinder(pos=self.axe0, axis=(0,-0.1,0), radius=0.3,color = color.blue)
                
         
        self.angle_bras1 =30
        self.anglemax1 = 135
        self.anglemin1 = 30
        self.angle_bras2 = 50
        self.anglemax2 = 190
        self.anglemin2 = 20
        self.angle_bras3 = 0
        self.anglemax3 = -135
        self.anglemin3 = -30
        
        
        size_bras1 = (1, 0.1, 0.1)
        (a1,b1,c1) = size_bras1 
        (x0,y0,z0) = self.axe0
        self.axe1 = ( x0 + (float(a1))*math.cos(math.radians((float(self.angle_bras1))))   , y0 + (float(a1))* (math.sin(math.radians((float(self.angle_bras1))))) , z0)
        
        
        size_bras2 = (1, 0.1, 0.1) 
        (a2,b2,c2) = size_bras2 
        (x1,y1,z1) = self.axe1
        
        m = a1-a2
        n = a2
        xp = (n*x0 + m*x1) / (n+m)
        yp = (n*y0 + m*y1) / (n+m)
        X2 = (xp-x1) * math.cos(math.radians((float(self.angle_bras2)))) - (yp-y1) * math.sin(math.radians((float(self.angle_bras2)))) +x1
        Y2 = (xp-x1) * math.sin(math.radians(float(self.angle_bras2))) + (yp-y1) * math.cos(math.radians(float(self.angle_bras2))) +y1
        
         
        
        self.axe2 = ( X2, Y2 , z1)
 
        
        size_bras3 = (0.5, 0.1, 0.1) 
        (a,b,c) = size_bras3  
        (x2,y2,z2) = self.axe2
        self.axe3 = ( x2 + (float(a))*math.cos(math.radians((float(self.angle_bras3))))   , y2 + (float(a))* (-math.sin(math.radians((float(self.angle_bras3))))) , z2)
        
        (x3,y3,z3) = self.axe3
        
        
        pos_bras1 = ( (x1+x0)/2 , (y1+y0)/2, z1)
        bras1 = box (pos=pos_bras1, size=size_bras1, axis = (x1-x0,y1-y0,z1-z0),  color = color.red)
        
        pos_bras2 = ( (x1+x2)/2 , (y1+y2)/2, z2)      
        bras2 = box (pos=pos_bras2, size=size_bras2, axis = (x2-x1,y2-y1,z2-z1),  color = color.green)
        
        pos_bras3 = ( (x2+x3)/2 , (y2+y3)/2, z3)      
        bras3 = box (pos=pos_bras3, size=size_bras3, axis = (x3-x2,y3-y2,z3-z2),  color = color.yellow)
        
        pince = sphere(pos=self.axe2, radius=0.1)
            
        c = controls() # Create controls window
        # Create a button in the controls window:
        
        
        s1 = slider(pos=(-15,-40),min=self.anglemin1,max=self.anglemax1, width=7, length=70, axis=(1,0,0),value =self.angle_bras1, action=lambda: update_bras1(s1,self.angle_bras1))
        
        s2 = slider(pos=(-15,-50),min=self.anglemin2,max=self.anglemax2, width=7, length=70, axis=(1,0,0),value =self.angle_bras2, action=lambda: update_bras2(s2,self.angle_bras2))
        
        s3 = slider(pos=(-15,-60),min=-135,max=135, width=7, length=70, axis=(1,0,0),value =self.angle_bras3, action=lambda: update_bras3(s3,self.angle_bras3))
        
        s4 = slider(pos=(-15,-80),min=-5,max=5, width=7, length=70, axis=(1,0,0),value =x2,range = 100000, action=lambda: move_robot_cercle(s4))
        b = button( pos=(0,0), width=60, height=60, text='Click me', action=lambda: change() )
        
        def change():
            
            move_robot_cercle(1)
        
        def update_bras1(obj,val): # Called by controls when button clicked
 
            
       
            
            self.angle_bras1 = obj.value
            angle = obj.value - val
            deplacer_bras1(angle)
            
        def deplacer_bras1(angle):
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
            
 
        def update_bras2(obj,val): # Called by controls when button clicked
 
            self.angle_bras2 = obj.value
            angle =obj.value - val 
            deplacer_bras2(angle)
            update_all()
            
        def deplacer_bras2(angle):
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
            
            
            
        def update_bras3(obj,val): # Called by controls when button clicked
 
            self.angle_bras3 = obj.value
            delta = val - obj.value
 
 
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            
            X3 = (x3-x2) * math.cos(math.radians((float(delta)))) - (y3-y2) * math.sin(math.radians((float(delta)))) +x2
            Y3 = (x3-x2) * math.sin(math.radians(float(delta))) + (y3-y2) * math.cos(math.radians(float(delta))) +y2
            
            self.axe3 = (X3,Y3,z3)
            
            update_all()
            
            
        def update_all():
 
 
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
            
            
        
        drag_pos = None # no object picked yet
        drag_bool = 1
        def grab(evt):
            global drag_pos
            global drag_bool
            if evt.pick == pince:
                drag_pos = evt.pickpos
                drag_bool = 1
                scene.bind('mousemove', move, pince)
                scene.bind('mouseup', drop)
        
        def move(evt, obj):
            global drag_pos
            global drag_bool
 
            
            # project onto xy plane, even if scene rotated:
            new_pos = scene.mouse.pos
 
            if new_pos != drag_pos: # if mouse has moved
                # offset for where the ball was touched:
                (xn,yn,zn) = new_pos - drag_pos
                (xo,yo,zo) = obj.pos  
                obj.pos = (xn+xo,yn+yo,zo)
                (xd,yd,zd) = obj.pos
                (x0,y0,z0) = self.axe0
                (a1,b1,c1) = size_bras1
                (a2,b2,c2) = size_bras2
                distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2)
                distanceAxe0versAxe1 = sqrt((x1-x2)**2 + (y1-y2)**2)
                
                if(distanceAxe0versDest <= (a1+a2)):
                    
                    drag_bool = move_robot(obj.pos)
                else:
                    print("grand")
                    print(xd)
                    print(x2)
                    print(distanceAxe0versDest)
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
            if(y1 == y0):
                deplacer_bras1(0.1)
                (x1,y1,z1) = self.axe1
                (x2,y2,z2) = self.axe2
                (x3,y3,z3) = self.axe3 
                
                
             
               
            ((xa,ya),(xb,yb)) = self.intersection_cercle(x0,y0,x1,y1,distanceAxe0versDest,a2)
            
            distanceInterAversAxe2 = sqrt((x2-xa)**2 + (y2-ya)**2)
            distanceInterBversAxe2 = sqrt((x2-xb)**2 + (y2-yb)**2)
            
            if(distanceInterAversAxe2 <= distanceInterBversAxe2):
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
            #print(angleInter)
            angleDestVersInter = angleDest - angleInter
            print(angleDestVersInter)
            
            
            deplacer_bras1(angleDestVersInter)
            
            
            
            
            
            (xr1,yr1) = (x1+a2,y1)
            
            distanceRefversDest = sqrt((xd-xr1)**2 + (yd-yr1)**2)
            angleDest = 2 * math.degrees(math.asin((distanceRefversDest /2) / a2 ))
            if(yd<yr1):
                angleDest = -angleDest
            
            distanceRefversAxe2 = sqrt((x2-xr1)**2 + (y2-yr1)**2)
            angleAxe2 = 2 * math.degrees(math.asin((distanceRefversAxe2 /2) / a2 ))
            if(y2<yr1):
                angleAxe2 = -angleAxe2
            
            angleAxe2VersDest = angleDest - angleAxe2 
            
            deplacer_bras2(angleAxe2VersDest)
        
            
            return 1
        
        
        
        
        
        def move_robot_cercle(obj):
            
           
            (xd,yd,zd) =  pince.pos
            xd = obj.value
            (x0,y0,z0) = self.axe0
            (x1,y1,z1) = self.axe1
            (x2,y2,z2) = self.axe2
            (x3,y3,z3) = self.axe3
            
            (a1,b1,c1) = size_bras1
            (a2,b2,c2) = size_bras2
            
 
            distanceAxe0versDest = sqrt((xd-x0)**2 + (yd-y0)**2)
            if(distanceAxe0versDest+a2 <a1):
                return 
            if(y1 == y0):
                deplacer_bras1(0.1)
                (x1,y1,z1) = self.axe1
                (x2,y2,z2) = self.axe2
                (x3,y3,z3) = self.axe3 
                
                
             
               
            ((xa,ya),(xb,yb)) = self.intersection_cercle(x0,y0,x1,y1,distanceAxe0versDest,a2)
            
            distanceInterAversAxe2 = sqrt((x2-xa)**2 + (y2-ya)**2)
            distanceInterBversAxe2 = sqrt((x2-xb)**2 + (y2-yb)**2)
            
            if(distanceInterAversAxe2 <= distanceInterBversAxe2):
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
            #print(angleInter)
            angleDestVersInter = angleDest - angleInter
            print(angleDestVersInter)
            
            
            deplacer_bras1(angleDestVersInter)
            
            
            
            
            
            (xr1,yr1) = (x1+a2,y1)
            
            distanceRefversDest = sqrt((xd-xr1)**2 + (yd-yr1)**2)
            angleDest = 2 * math.degrees(math.asin((distanceRefversDest /2) / a2 ))
            if(yd<yr1):
                angleDest = -angleDest
            
            distanceRefversAxe2 = sqrt((x2-xr1)**2 + (y2-yr1)**2)
            angleAxe2 = 2 * math.degrees(math.asin((distanceRefversAxe2 /2) / a2 ))
            if(y2<yr1):
                angleAxe2 = -angleAxe2
            
            angleAxe2VersDest = angleDest - angleAxe2 
            
            deplacer_bras2(angleAxe2VersDest)
        
            
            
            
            
           
 
                
                
        
        
    def intersection_cercle(self,x0,y0,x1,y1,a1,a2):
         
        
        
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
        print("a")  
        return (Xa,Xb)
