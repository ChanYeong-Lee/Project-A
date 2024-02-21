using UnityEngine;

public class GameManager
{
    // Game System
    private bool isPause;
    private bool isFullScreen;
    
    public bool IsPause
    {
        get => isPause;
        set
        {
            isPause = value;
            Time.timeScale = isPause ? 0 : 1;
        }
    }
    
    public bool IsFullScreenMode
    {
        get => isFullScreen;
        set
        { 
            isFullScreen = value;
            Screen.fullScreen = isFullScreen;
        }
    }

    public void Init()
    {
        
    }
    
}