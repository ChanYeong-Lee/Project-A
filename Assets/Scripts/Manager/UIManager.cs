using UnityEngine;

public class UIManager
{
    private bool uiOpen;
    public bool UIOpen => uiOpen;
    
    private GameObject hudCanvas;
    private GameObject mainCanvas;

    public GameObject HUDCanvas { get => hudCanvas; set => hudCanvas = value; }
    public GameObject MainCanvas { get => mainCanvas; set => mainCanvas = value; }

    private HUDUI hudUI;
    private MainUI mainUI;

    public HUDUI HUDUI => hudUI;
    public MainUI MainUI => mainUI;

    public void Init()
    {
        CreateEventSystem();
        CreateGameUI();
    }

    private void CreateEventSystem()
    {
        if (GameObject.Find("EventSystem") == null) 
            Managers.Resource.Instantiate("Prefabs/UI/EventSystem");
    }

    private void CreateGameUI()
    {
        // HUD
        if (hudCanvas == null)
        {
            GameObject go = GameObject.Find("HUDCanvas");
            hudCanvas = go == null ? Managers.Resource.Instantiate("Prefabs/UI/HUDCanvas") : go;
            hudUI = hudCanvas.GetComponentInChildren<HUDUI>(true);
        }
        
        // MainCanvas
        if (mainCanvas == null)
        {
            GameObject go = GameObject.Find("MainCanvas");
            mainCanvas = go == null ? Managers.Resource.Instantiate("Prefabs/UI/MainCanvas") : go;
            mainUI = hudCanvas.GetComponentInChildren<MainUI>(true);
        }
    }

    public void OpenMainUI()
    {
        mainUI.gameObject.SetActive(true);
    }

    public void CloseMainUI()
    {
        mainUI.gameObject.SetActive(false);
    }
}