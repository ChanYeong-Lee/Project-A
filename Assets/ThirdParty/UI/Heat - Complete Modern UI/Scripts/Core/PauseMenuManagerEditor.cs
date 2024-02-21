#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

namespace Michsky.UI.Heat
{
    [CanEditMultipleObjects]
    [CustomEditor(typeof(PauseMenuManager))]
    public class PauseMenuManagerEditor : Editor
    {
        private PauseMenuManager pmmTarget;
        private GUISkin customSkin;

        private void OnEnable()
        {
            pmmTarget = (PauseMenuManager)target;

            if (EditorGUIUtility.isProSkin == true) { customSkin = HeatUIEditorHandler.GetDarkEditor(customSkin); }
            else { customSkin = HeatUIEditorHandler.GetLightEditor(customSkin); }
        }

        public override void OnInspectorGUI()
        {
            var pauseMenuCanvas = serializedObject.FindProperty("pauseMenuCanvas");
            var continueButton = serializedObject.FindProperty("continueButton");
            var panelManager = serializedObject.FindProperty("panelManager");
            var background = serializedObject.FindProperty("background");

            var setTimeScale = serializedObject.FindProperty("setTimeScale");
            var inputBlockDuration = serializedObject.FindProperty("inputBlockDuration");
            var menuCursorState = serializedObject.FindProperty("menuCursorState");
            var gameCursorState = serializedObject.FindProperty("gameCursorState");
            var menuCursorVisibility = serializedObject.FindProperty("menuCursorVisibility");
            var gameCursorVisibility = serializedObject.FindProperty("gameCursorVisibility");
            var hotkey = serializedObject.FindProperty("hotkey");

            var onOpen = serializedObject.FindProperty("onOpen");
            var onClose = serializedObject.FindProperty("onClose");

            if (pmmTarget.pauseMenuCanvas != null)
            {
                HeatUIEditorHandler.DrawHeader(customSkin, "Content Header", 6);
                GUILayout.BeginHorizontal();

                if (Application.isPlaying == false)
                {
                    if (pmmTarget.pauseMenuCanvas.gameObject.activeSelf == false && GUILayout.Button("Show Pause Menu", customSkin.button))
                    {
                        pmmTarget.pauseMenuCanvas.gameObject.SetActive(true);
                        EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
                    }

                    else if (pmmTarget.pauseMenuCanvas.gameObject.activeSelf == true && GUILayout.Button("Hide Pause Menu", customSkin.button))
                    {
                        pmmTarget.pauseMenuCanvas.gameObject.SetActive(false);
                        EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
                    }
                }

                if (GUILayout.Button("Select Object", customSkin.button)) { Selection.activeObject = pmmTarget.pauseMenuCanvas; }
                GUILayout.EndHorizontal();
            }

            HeatUIEditorHandler.DrawHeader(customSkin, "Core Header", 10);
            HeatUIEditorHandler.DrawProperty(pauseMenuCanvas, customSkin, "Pause Canvas");
            HeatUIEditorHandler.DrawProperty(continueButton, customSkin, "Continue Button");
            HeatUIEditorHandler.DrawProperty(panelManager, customSkin, "Panel Manager");
            HeatUIEditorHandler.DrawProperty(background, customSkin, "Background");

            HeatUIEditorHandler.DrawHeader(customSkin, "Options Header", 10);
            setTimeScale.boolValue = HeatUIEditorHandler.DrawToggle(setTimeScale.boolValue, customSkin, "Set Time Scale", "Sets the time scale depending on the pause menu state.");
            HeatUIEditorHandler.DrawPropertyCW(inputBlockDuration, customSkin, "Input Block Duration", "Block input in specific amount of time to provide smooth visuals.", 140);
            HeatUIEditorHandler.DrawPropertyCW(menuCursorState, customSkin, "Menu Cursor State", 140);
            HeatUIEditorHandler.DrawPropertyCW(menuCursorVisibility, customSkin, "Menu Cursor Visibility", 140);
            HeatUIEditorHandler.DrawPropertyCW(gameCursorState, customSkin, "Game Cursor State", 140);
            HeatUIEditorHandler.DrawPropertyCW(gameCursorVisibility, customSkin, "Game Cursor Visibility", 140);
            EditorGUILayout.PropertyField(hotkey, new GUIContent("Hotkey"), true);

            HeatUIEditorHandler.DrawHeader(customSkin, "Events Header", 10);
            EditorGUILayout.PropertyField(onOpen, new GUIContent("On Open"), true);
            EditorGUILayout.PropertyField(onClose, new GUIContent("On Close"), true);

            serializedObject.ApplyModifiedProperties();
        }
    }
}
#endif