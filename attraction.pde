final float G = 1500;
ArrayList<Object> objects;

boolean gravity;
boolean collision;
boolean edges;

float outerForceStrength;

void setup(){
  //size(900 , 900);
  fullScreen();
  objects = new ArrayList<Object>();
  gravity = true;
  collision = true;
  edges = true;
  
  outerForceStrength = 1;
}

void draw(){
  background(150);
  
  if(gravity){
    for(int i = 0; i < objects.size(); i++){
      for(int j = 0; j < objects.size(); j++){
        if( i != j){
          objects.get(i).attract(objects.get(j));
        }
      }
    }
  }
  
  if(collision){
    for(int i = 0; i < objects.size(); i++){
      for(int j = i+1; j < objects.size(); j++){
        if( mydist( objects.get(i).position , objects.get(j).position) < objects.get(i).radius + objects.get(j).radius ){
          objects.get(i).collide(objects.get(j));
        }
      }
    }
  }
  
  for(Object object : objects){ 
    
    if(edges){
      if(object.position.x > width - object.radius){
        object.position.x = width-object.radius;
        object.velocity.x *= -1;
      }
      
      if(object.position.x < object.radius){
        object.position.x = object.radius;
        object.velocity.x *= -1;
      }
      
      if(object.position.y > height - object.radius){
        object.position.y = height-object.radius;
        object.velocity.y *= -1;
      }
      
      if(object.position.y < object.radius){
        object.position.y = object.radius;
        object.velocity.y *= -1;
      }
    }
    
    object.update();
    object.show();
  }
  
  
  textSize(20);
  textAlign(LEFT , TOP);
  text("Gravity: " + ((gravity) ? "True" : "False") + " (g)" , 10 , 10);
  text("Collision: " + ((collision) ? "True" : "False") + " (c)" , 10 , 30);
  text("Edges: " + ((edges) ? "True" : "False") + " (e)", 10 , 50);
  
}

void mousePressed(){
  objects.add(new Object(2 , mouseX , mouseY));
}

void keyPressed(){
  if(key == 'x'){
    objects.clear();
  }else if(key == 'g'){
    gravity = !gravity;
  }else if(key == 'c'){
    collision = !collision;
  }else if(key == 'e'){
    edges = !edges;
  }else if(keyCode == UP || keyCode == DOWN || keyCode == RIGHT || keyCode == LEFT){
    for(Object object : objects){
      if(object.containsMouse()){
        
        if(keyCode == UP){
          object.applyForce(new PVector(0 , -outerForceStrength));
        }
        
        if(keyCode == DOWN){
          object.applyForce(new PVector(0 , outerForceStrength));
        }
        
        if(keyCode == RIGHT){
          object.applyForce(new PVector(outerForceStrength , 0));
        }
        
        if(keyCode == LEFT){
          object.applyForce(new PVector(-outerForceStrength , 0));
        }
        
      }
    }
  }
}
