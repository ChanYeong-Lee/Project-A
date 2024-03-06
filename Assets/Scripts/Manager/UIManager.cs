using UnityEngine;

public class UIManager
{
    private bool uiOpen;
    public bool UIOpen => uiOpen;
    
    private GameObject hud;
    private GameObject mainUI;

    public GameObject HUD { get => hud; set => hud = value; }
    public GameObject MainUI { get => mainUI; set => mainUI = value; }

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
        if (hud == null)
        {
            GameObject go = GameObject.Find("HUDCanvas");
            hud = go == null ? Managers.Resource.Instantiate("Prefabs/UI/HUDCanvas") : go;
        }
        
        // MainCanvas
        if (mainUI == null)
        {
            GameObject go = GameObject.Find("MainCanvas");
            hud = go == null ? Managers.Resource.Instantiate("Prefabs/UI/MainCanvas") : go;
        }
    }

    public void OpenMainUI()
    {
        mainUI.GetComponentInChildren<MainUI>(true).gameObject.SetActive(true);
    }

    public void CloseMainUI()
    {
        mainUI.GetComponentInChildren<MainUI>(true).gameObject.SetActive(false);
    }
}