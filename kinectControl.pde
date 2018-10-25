import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;

void kinectControl()
{
  
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
}

void kinectDraw()
{
  for (int i=0; i<bodies.size (); i++) 
  {
    drawPosition(bodies.get(i));
  }
}
void drawPosition(SkeletonData _s) 
{
  if(_s.skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED ){
     
      float[] mouse = {_s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width, 
                     _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height};
      particlesystem.particles[0].moveTo(mouse, 0.3f);
      particlesystem.particles[0].enableCollisions(false);
      print(mouse[0]);
    } else {
      particlesystem.particles[0].enableCollisions(true);
    }
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}
