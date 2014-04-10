# -*- cod	ing: utf-8 -*-
'''
Created on 8 avr. 2014

@author: Adam & Radhoane
'''
from visual import *
from visual.controls import *
import math

class Dessin(object):
    '''
    classdocs
    '''


    def __init__(self, robot,scene_courante):
        '''
        Constructor
        '''
        
        
        (x0,y0,z0) = robot.axe0
        (x1,y1,z1) = robot.axe1
        (x2,y2,z2) = robot.axe2
        (x3,y3,z3) = robot.axe3
        (a3,b2,c2) = robot.size_bras3
        
        
        pos_bras1 = ( (x1+x0)/2 , (y1+y0)/2, z1)
        pos_bras2 = ( (x1+x2)/2 , (y1+y2)/2, z2)
        pos_bras3 = ( (x2+x3)/2 , (y2+y3)/2, z3)
        
        #Cr�ation des trois bras, de l'objectif � atteindre et des articulations
        self.bras1 = box (display = scene_courante, pos=pos_bras1, size=robot.size_bras1, axis = (x1-x0,y1-y0,z1-z0),  color = color.red)
        self.bras2 = box (display = scene_courante,pos=pos_bras2, size=robot.size_bras2, axis = (x2-x1,y2-y1,z2-z1),  color = color.blue)      
        self.bras3 = box (display = scene_courante,pos=pos_bras3, size=robot.size_bras3, axis = (x3-x2,y3-y2,z3-z2),  color = color.green)
        self.articulation = sphere(display = scene_courante,pos=robot.axe1, radius=0.1, color = color.white)
        self.articulation2 = sphere(display = scene_courante,pos=robot.axe2, radius=0.1,color = color.white)
        #self.pince = sphere(display = scene_courante,pos=robot.axe2, radius=0.1)
         #Dessin du socle
        self.socle = cylinder(display = scene_courante,pos=robot.axe0, axis=(0,-0.2,0), radius=0.3,color = color.gray(0.7))
        #Dessin des deux rotor sur le socle
        self.rotorA = box (display = scene_courante,pos=(1,-0.9,1.9),size = (0.3,0.1,0.1),axis=(0,1,0), color = color.gray(0.7))
        self.rotorB = box (display = scene_courante,pos=(1,-0.9,2.1),size = (0.3,0.1,0.1),axis=(0,1,0), color = color.gray(0.7))
    
        (xr,yr) = (x2+a3,y2)
        
        distanceRefversAxe3 = sqrt((x3-xr)**2 + (y3-yr)**2)
        self.angleAxe3 = 2 * math.degrees(math.asin((distanceRefversAxe3 /2) / a3 ))
            #print((distanceRefversDest /2) / a2 )
        self.pince1 = box (display = scene_courante, pos=(x3+ (0.025) * cos(radians(self.angleAxe3)),y3 + (0.025) * sin(radians(self.angleAxe3)),z3),size = (0.3,0.1,0.05),axis=(0,0,1), color = color.gray(0.7))
        self.pince1.rotate(angle=radians(self.angleAxe3), axis=(0,0,1), origin=self.pince1.pos)
        self.pince1_deviation = 0
        self.pince2_deviation = 0
        self.pince2 = pyramid (display = scene_courante, pos=(x3+ (0.025) * cos(radians(self.angleAxe3)),y3 + (0.025) * sin(radians(self.angleAxe3)),z3+self.pince1_deviation-0.125),size = (0.3,0.1,0.05),axis=(1,0,0), color = color.gray(0.7))
        self.pince2.rotate(angle=radians(self.angleAxe3), axis=(0,0,1), origin=self.pince1.pos)
        
        self.pince3 = pyramid (display = scene_courante, pos=(x3+ (0.025) * cos(radians(self.angleAxe3)),y3 + (0.025) * sin(radians(self.angleAxe3)),z3-self.pince2_deviation+0.125),size = (0.3,0.1,0.05),axis=(1,0,0), color = color.gray(0.7))
        self.pince3.rotate(angle=radians(self.angleAxe3), axis=(0,0,1), origin=self.pince1.pos)
        
        
        
        
        if(scene_courante == robot.scene_camera):
            
            
            size_socle_camera = (0.1,0.3,0.05)
            
            (a,b,c) = size_socle_camera 
            
            self.socle_camera = box (display = scene_courante, pos=(x3 - (0.2) * cos(radians(self.angleAxe3))- (b/2)*sin(radians(self.angleAxe3)),y3 - (0.2) * sin(radians(self.angleAxe3)) +(b/2)*cos(radians(self.angleAxe3)) ,z3),size = (a,b,c),axis=(0,0,1), color = color.gray(0.7))
            self.socle_camera.rotate(angle=radians(self.angleAxe3), axis=(0,0,1), origin=self.socle_camera.pos)
            
            
            self.camera = sphere(display = scene_courante,pos=(x3 - (0.2) * cos(radians(self.angleAxe3))- (b)*sin(radians(self.angleAxe3)),y3 - (0.2) * sin(radians(self.angleAxe3)) +(b)*cos(radians(self.angleAxe3)) ,z3), radius=0.05)
            size_socle_champs = (1,0.5,0.5)
            (a,b,c) = size_socle_champs
            
            (x,y,z) = self.camera.pos
            
            self.champs_vision = pyramid(display = scene_courante,pos=(x + (a) * cos(radians(self.angleAxe3)),y + (a) * sin(radians(self.angleAxe3)) ,z3), size=(a,b,c),axis = (1,0,0), color = color.red)
            self.champs_vision.opacity = 0.2
            (x,y,z) = self.camera.pos

            self.champs_vision.rotate(angle=radians(180),axis=(0,0,1),origin=self.champs_vision.pos)
        
        
            self.marqueur = box(display = scene_courante, pos = (2,0.5,2.5),size=(0.05,0.1,0.1),color = color.gray(0.5))
        
        
        
        
        
        
        
        
        
        
        
        
        
