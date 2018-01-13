//interact with body
void kickball(PVector p, ball ba){
  float di = PVector.dist(p, ba.position);
  if(di < 200){
    PVector push = PVector.sub(ba.position, p);
    push.normalize();
    push.mult(30);
    push.div(ba.mass);
    ba.velocity.add(push);
  }
  
}



//interact with music
void attractball(PVector p, ball b, float k){
  float d = PVector.dist(p, b.position);
  if(d<200){
    PVector pull = PVector.sub(p, b.position);
    pull.normalize();
    pull.mult(k);
    pull.div(b.mass);
    b.velocity.add(pull);
  }
}