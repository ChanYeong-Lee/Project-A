using UnityEngine;

public class UIManager
{
    private bool isOpenedUI;
    public bool IsOpenedUI => isOpenedUI;
    
    private GameObject hudCanvas;
    private GameObject mainCanvas;

    public GameObject HUDCanvas { get => hudCanvas; set => hudCanvas = value; }
    public GameObject MainCanvas { get => mainCanvas; set => mainCanvas = value; }

    private HUDUI hudUI;
    private MainUI mainUI;
    public LoadingUI loadingUI;

    public HUDUI HUDUI => hudUI;
    public MainUI MainUI => mainUI;
    public LoadingUI LoadingUI => loadingUI;

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

    public void CreateTitleUI()
    {
        
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
            mainUI = mainCanvas.GetComponentInChildren<MainUI>(true);
        }
    }

    public void CreateLoadingUI()
    {
        if (loadingUI == null)
        {
            GameObject go = GameObject.Find("HUDCanvas");
            loadingUI = (go == null ? Managers.Resource.Instantiate("Prefabs/UI/loadingUI") : go)
                .GetComponent<LoadingUI>();
        }
    }

    public void OpenMainUI()
    {
        mainUI.gameObject.SetActive(true);
        isOpenedUI = true;
        Managers.Game.IsPause = true;
        Managers.Cursor.ChangeCursorState(CursorManager.CursorState.UI);
        Managers.Input.OpenUI();
    }

    public void CloseMainUI()
    {
        mainUI.gameObject.SetActive(false);
        isOpenedUI = false;
        Managers.Game.IsPause = false;
        Managers.Cursor.ChangeCursorState(CursorManager.CursorState.OnGame);
        Managers.Input.CloseUI();
        
    }
}