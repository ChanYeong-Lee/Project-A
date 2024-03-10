using UnityEngine;

public class UIManager
{
    private bool isOpenedUI;
    public bool IsOpenedUI => isOpenedUI;

    private GameObject hudCanvas;
    private GameObject mainCanvas;
    private GameObject dialogCanvas;

    public GameObject HUDCanvas { get => hudCanvas; set => hudCanvas = value; }
    public GameObject MainCanvas { get => mainCanvas; set => mainCanvas = value; }

    public GameObject DialogCanvas { get => dialogCanvas; set => dialogCanvas = value; }

    private HUDUI hudUI;
    private MainUI mainUI;
    private DialogSystem uiDialog;

    public HUDUI HUDUI => hudUI;
    public MainUI MainUI => mainUI;

    public DialogSystem UIDialog => uiDialog;

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
            mainUI = mainCanvas.GetComponentInChildren<MainUI>(true);
        }
        if (DialogCanvas == null)
        {
            GameObject go = GameObject.Find("DialogCanvas");
            dialogCanvas = go == null ? Managers.Resource.Instantiate("Prefabs/UI/DialogCanvas") : go;
            uiDialog = dialogCanvas.GetComponentInChildren<DialogSystem>(true);
        }
    }

    public void OpenMainUI()
    {
        mainUI.gameObject.SetActive(true);
        isOpenedUI = true;
    }

    public void CloseMainUI()
    {
        mainUI.gameObject.SetActive(false);
        isOpenedUI = false;
    }

    public void OpenDialogUI()
    {
        uiDialog.gameObject.SetActive(true);
        isOpenedUI = true;
    }
    public void CloseDialogUI()
    {
        uiDialog.gameObject.SetActive(false);
        isOpenedUI = false;
    }

}