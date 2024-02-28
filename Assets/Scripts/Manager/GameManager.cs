using UnityEngine;


public class GameManager : MonoBehaviour
{
    // Game System
    private bool isPause;
    private bool isFullScreen;
    [Range(1f, 16f)] public float gameSpeed = 1f ;
    
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
    private void Update()
    {
        
    }
    public void Init()
    {
        
    }
    
}