using System;

public class MiscEvents
{
    public Action<int> onWoodCollected;
    public void WoodCollected(int count)
    {
        if(onWoodCollected != null)
        {
            onWoodCollected(count);
        }
    }
}
