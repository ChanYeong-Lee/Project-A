using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CursorManager : MonoBehaviour
{
    public enum CursorState
    {
        UI,
        OnGame,
    }

    private CursorState state;

    private void OnApplicationFocus(bool focus)
    {
        if (focus)
        {
            switch (state)
            {
                case CursorState.OnGame:
                    Cursor.visible = false;
                    Cursor.lockState = CursorLockMode.Locked;
                    break;
                case CursorState.UI:
                    Cursor.visible = true;
                    Cursor.lockState = CursorLockMode.Confined;
                    break;
            }
        }
        else
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
    }

    public void ChangeCursorState(CursorState state)
    {
        this.state = state;
        OnApplicationFocus(true);
    }
}
