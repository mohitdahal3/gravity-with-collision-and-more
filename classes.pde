class Object{
  float mass;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float radius;

  Object(float m , float x , float y){
    this.mass = m;
    this.position = new PVector(x , y);
    this.velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
    this.force = new PVector(0,0);
    radius = mass * 10;
  }
  
  void show(){
    noStroke();
    fill(0);
    circle(this.position.x , this.position.y , this.radius * 2);
  }
  
  void update(){
    this.acceleration = PVector.div(this.force.copy() , this.mass);
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    
    this.acceleration.mult(0);
    this.force.mult(0);
  }
  
  void applyForce(PVector f){
    this.force.add(f.copy());
  }
  
  void attract(Object other){
    float r = sqrt( pow(other.position.x - this.position.x , 2) + pow(other.position.y - this.position.y , 2) );
    
    if(r < this.radius + other.radius){
      r = this.radius + other.radius;
    }
    
    float mag = (G * this.mass * other.mass) / pow(r+100 , 2);
    PVector gravityForce = PVector.sub(this.position.copy() , other.position.copy());
    gravityForce.setMag(mag);
    
    other.applyForce(gravityForce);
  }
  
  void collide(Object other){
    PVector centerDisplacementA = PVector.sub(other.position.copy() , this.position.copy());
    PVector centerDisplacementB = PVector.sub(this.position.copy() , other.position.copy());
    
    float angleA = PVector.angleBetween(this.velocity , centerDisplacementA);
    float angleB = PVector.angleBetween(other.velocity , centerDisplacementB);
    
    float va1 , va2 , vb1 , vb2;
    
    va1 = this.velocity.mag() * cos(angleA);
    vb1 = other.velocity.mag() * cos(angleB) * -1;
    
    PVector effectiveVelocityA = centerDisplacementA.copy().setMag(va1);
    PVector perpVelocityA = PVector.sub(this.velocity , effectiveVelocityA);
  
    PVector effectiveVelocityB = centerDisplacementB.copy().setMag(-vb1);
    PVector perpVelocityB = PVector.sub(other.velocity , effectiveVelocityB);

    
    va2 = ( ((this.mass - other.mass)/(this.mass + other.mass)) * (va1)) + ( ((2 * other.mass)/(this.mass + other.mass)) *(vb1) ); 
    vb2 = ( ((other.mass - this.mass)/(this.mass + other.mass)) * (vb1)) + ( ((2 * this.mass)/(this.mass + other.mass))*(va1) );
    
    effectiveVelocityA.setMag(va2);
    effectiveVelocityB.setMag(-vb2);
    
    this.velocity = PVector.add(effectiveVelocityA , perpVelocityA);
    other.velocity = PVector.add(effectiveVelocityB , perpVelocityB);
    
    if(centerDisplacementA.mag() < this.radius + other.radius){
      float overlap = this.radius + other.radius - centerDisplacementA.mag();
      this.position.add(centerDisplacementA.copy().setMag(overlap/-2));
      other.position.add(centerDisplacementB.copy().setMag(overlap/-2));
    }
  }

  
  boolean containsMouse(){
    return (dist(this.position.x , this.position.y , mouseX , mouseY) < this.radius);
  }

}


float mydist(PVector p1 , PVector p2){
  return dist(p1.x , p1.y , p2.x , p2.y);
}
