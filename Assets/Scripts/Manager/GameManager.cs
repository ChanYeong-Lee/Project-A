using UnityEngine;


public class GameManager
{
    // Game System
    private bool isPause;
    private bool isFullScreen;
    private float gameSpeed;
    
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

    public float GameSpeed
    {
        get => gameSpeed;
        set
        {
            gameSpeed = value;
            Time.timeScale = gameSpeed;
        }
    }

    public void Init()
    {
        
    }
    
}