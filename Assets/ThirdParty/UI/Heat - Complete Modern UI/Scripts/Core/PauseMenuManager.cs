using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;

namespace Michsky.UI.Heat
{
    public class PauseMenuManager : MonoBehaviour
    {
        // Resources
        public GameObject pauseMenuCanvas;
        [SerializeField] private ButtonManager continueButton;
        [SerializeField] private PanelManager panelManager;
        [SerializeField] private ImageFading background;

        // Settings
        [SerializeField] private bool setTimeScale = true;
        [Range(0, 1)] public float inputBlockDuration = 0.2f;
        public CursorLockMode menuCursorState = CursorLockMode.None;
        public CursorLockMode gameCursorState = CursorLockMode.Locked;
        public CursorVisibility menuCursorVisibility = CursorVisibility.Visible;
        public CursorVisibility gameCursorVisibility = CursorVisibility.Default;
        [SerializeField] private InputAction hotkey;

        // Events
        public UnityEvent onOpen = new UnityEvent();
        public UnityEvent onClose = new UnityEvent();

        // Helpers
        bool isOn = false;
        bool allowClosing = true;
        float disableAfter = 0.6f;

        public enum CursorVisibility { Default, Invisible, Visible }

        void Awake()
        {
            if (pauseMenuCanvas == null)
            {
                Debug.LogError("<b>[Pause Menu Manager]</b> Pause Menu Canvas is missing!", this);
                this.enabled = false;
                return;
            }

            pauseMenuCanvas.SetActive(true);
        }

        void Start()
        {
            if (panelManager != null) { disableAfter = HeatUIInternalTools.GetAnimatorClipLength(panelManager.panels[panelManager.currentPanelIndex].panelObject, "MainPanel_Out"); }
            if (continueButton != null) { continueButton.onClick.AddListener(ClosePauseMenu); }

            pauseMenuCanvas.SetActive(false);
            hotkey.Enable();
        }

        void Update()
        {
            if (hotkey.triggered) { AnimatePauseMenu(); }
        }

        public void AnimatePauseMenu()
        {
            if (!isOn) { OpenPauseMenu(); }
            else { ClosePauseMenu(); }
        }

        public void OpenPauseMenu()
        {
            if (isOn) { return; }
            if (setTimeScale) { Time.timeScale = 0; }
            if (inputBlockDuration > 0)
            {
                AllowClosing(false);
                StopCoroutine("InputBlockProcess");
                StartCoroutine("InputBlockProcess");
            }

            StopCoroutine("DisablePauseCanvas");

            isOn = true;
            onOpen.Invoke();

            pauseMenuCanvas.SetActive(false);
            pauseMenuCanvas.SetActive(true);

            FadeInBackground();

            Cursor.lockState = menuCursorState;

            if (menuCursorVisibility == CursorVisibility.Visible) { Cursor.visible = true; }
            else if (menuCursorVisibility != CursorVisibility.Default) { Cursor.visible = false; }

            if (continueButton != null && Gamepad.current != null)
            {
                EventSystem.current.SetSelectedGameObject(null);
                EventSystem.current.SetSelectedGameObject(continueButton.gameObject);
            }
        }

        public void ClosePauseMenu()
        {
            if (!isOn || !allowClosing) { return; }
            if (setTimeScale == true) { Time.timeScale = 1; }
            if (panelManager != null) { panelManager.HideCurrentPanel(); }

            StopCoroutine("DisablePauseCanvas");
            StartCoroutine("DisablePauseCanvas");

            if (gameCursorVisibility == CursorVisibility.Visible) { Cursor.visible = true; }
            else if (gameCursorVisibility != CursorVisibility.Default) { Cursor.visible = false; }

            isOn = false;
            onClose.Invoke();

            FadeOutBackground();

            Cursor.lockState = gameCursorState;
        }

        public void FadeInBackground()
        {
            if (background == null)
                return;

            background.FadeIn();
        }

        public void FadeOutBackground()
        {
            if (background == null)
                return;

            background.FadeOut();
        }

        public void AllowClosing(bool value)
        {
            allowClosing = value;
        }

        IEnumerator DisablePauseCanvas()
        {
            yield return new WaitForSecondsRealtime(disableAfter);
            pauseMenuCanvas.SetActive(false);
        }

        IEnumerator InputBlockProcess()
        {
            yield return new WaitForSecondsRealtime(inputBlockDuration);
            AllowClosing(true);
        }
    }
}