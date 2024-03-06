using UnityEngine;
using UnityEngine.InputSystem;

// This script acts as a proxy for the PlayerInput component
// such that the input events the game needs to proces will 
// be sent through the GameEventManager. This lets any other
// script in the project easily subscribe to an input action
// without having to deal with the PlayerInput component directly.

[RequireComponent(typeof(PlayerInput))]
public class InputManager : MonoBehaviour
{
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

    public void OnMove(InputValue value)
    {
        move = value.Get<Vector2>().normalized;
    }

    public void OnLook(InputValue value)
    {
        look = value.Get<Vector2>();
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
        mousePos = value.Get<Vector2>();
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




    //public void MovePressed(InputAction.CallbackContext context)
    //{
    //    if (context.performed || context.canceled)
    //    {
    //        GameEventsManager.Instance.inputEvents.MovePressed(context.ReadValue<Vector2>());
    //    }
    //}

    //public void SubmitPressed(InputAction.CallbackContext context)
    //{
    //    if (context.started)
    //    {
    //        GameEventsManager.Instance.inputEvents.SubmitPressed();
    //    }
    //}

    //public void QuestLogTogglePressed(InputAction.CallbackContext context)
    //{
    //    if (context.started)
    //    {
    //        GameEventsManager.Instance.inputEvents.QuestLogTogglePressed();
    //    }
    //}
}
