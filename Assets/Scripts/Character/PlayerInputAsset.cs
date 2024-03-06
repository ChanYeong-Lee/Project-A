using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInputAsset : MonoBehaviour
{

    public enum State { None, Mount }
    public State state;

    [Header("Character Input Values")]
    public Vector2 move;
    public Vector2 look;
    public Vector2 mousePos;
    public bool jump;
    public bool sprint;
    public bool leftClick;
    public bool rightClick;
    public bool hKey;
    public bool eKey;
    public bool iKey;
    public bool cKey;
    public bool qKey;
    public bool mKey;
    public bool enter;
    public bool tab;
    public bool esc;

    [Header("Movement Settings")]
    public bool analogMovement;

    [Header("Mouse Cursor Settings")]
    public bool cursorLocked = true;
    public bool cursorInputForLook = true;

    public void OnMove(InputValue value)
    {
        move = value.Get<Vector2>().normalized;
    }

    public void OnLook(InputValue value)
    {
        if (cursorInputForLook)
        {
            look = value.Get<Vector2>();
        }
    }

    public void OnJump(InputValue value)
    {
        jump = value.isPressed;
    }

    public void OnSprint(InputValue value)
    {
        sprint = value.isPressed;
    }

    public void OnLeftClick(InputValue value)
    {
        leftClick = value.isPressed;    
    } 

    public void OnRightClick(InputValue value)
    {
        rightClick = value.isPressed;
    }

    public void OnMousePos(InputValue value)
    {
        mousePos= value.Get<Vector2>();
    }

    public void OnHKey(InputValue value)
    {
        hKey = value.isPressed;
    }

    public void OnEKey(InputValue value)
    {
        eKey = value.isPressed;
    }
    public void OnIKey(InputValue value)
    {
        iKey = value.isPressed;
    }
    public void OnCKey(InputValue value)
    {
        cKey = value.isPressed;
    }
    public void OnESC(InputValue value)
    {
        esc = value.isPressed;
    }
    public void OnQKey(InputValue value)
    {
        qKey = value.isPressed;
    }
    public void OnMKey(InputValue value)
    {
        mKey = value.isPressed;
    }
    public void OnEnter(InputValue value)
    {
        enter = value.isPressed;
        print(value.isPressed);
    }
    public void OnTab(InputValue value)
    {
        tab = value.isPressed;
        print(value.isPressed);
    }
}