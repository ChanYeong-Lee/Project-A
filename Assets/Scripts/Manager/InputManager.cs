using System;
using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(PlayerInput))]
public class InputManager : MonoBehaviour
{
    private StarterAssets input;
    
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

    private void Awake()
    {
        input = new StarterAssets();
        input.Player.EKey.started += _ => Managers.Game.Player.GetComponent<CharacterInteraction>().Farming();
    }

    private void OnEnable()
    {
        input.Enable();
    }

    private void Update()
    {
        // print(hKey);
    }

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
        if (Managers.UI.IsOpenedUI)
        {
            if (Managers.UI.MainUI.CurrentMenu != MenuType.Inventory)
            {
                Managers.UI.MainUI.SelectMenu(MenuType.Inventory);
            }
            else
            {
                Managers.UI.CloseMainUI();
            }
        }
        else
        {
            Managers.UI.OpenMainUI();
            Managers.UI.MainUI.OpenMainUI(MenuType.Inventory);
        }
        
        iKey = value.isPressed;
    }
    public void OnCKey(InputValue value)
    {
        if (Managers.UI.IsOpenedUI)
        {
            if (Managers.UI.MainUI.CurrentMenu != MenuType.Crafting)
            {
                Managers.UI.MainUI.SelectMenu(MenuType.Crafting);
            }
            else
            {
                Managers.UI.CloseMainUI();
            }
        }
        else
        {
            Managers.UI.OpenMainUI();
            Managers.UI.MainUI.OpenMainUI(MenuType.Crafting);
        }
        cKey = value.isPressed;
    }
    public void OnESC(InputValue value)
    {
        if (Managers.UI.IsOpenedUI)
        {
            if (Managers.UI.MainUI.CurrentMenu != MenuType.Settings)
            {
                Managers.UI.MainUI.SelectMenu(MenuType.Settings);
            }
            else
            {
                Managers.UI.CloseMainUI();
            }
        }
        else
        {
            Managers.UI.OpenMainUI();
            Managers.UI.MainUI.OpenMainUI(MenuType.Settings);
        }
        esc = value.isPressed;
    }
    public void OnQKey(InputValue value)
    {
        if (Managers.UI.IsOpenedUI)
        {
            if (Managers.UI.MainUI.CurrentMenu != MenuType.Quest)
            {
                Managers.UI.MainUI.SelectMenu(MenuType.Quest);
            }
            else
            {
                Managers.UI.CloseMainUI();
            }
        }
        else
        {
            Managers.UI.OpenMainUI();
            Managers.UI.MainUI.OpenMainUI(MenuType.Quest);
        }

        qKey = value.isPressed;
    }
    public void OnMKey(InputValue value)
    {
        if (Managers.UI.IsOpenedUI)
        {
            if (Managers.UI.MainUI.CurrentMenu != MenuType.Map)
            {
                Managers.UI.MainUI.SelectMenu(MenuType.Map);
            }
            else
            {
                Managers.UI.CloseMainUI();
            }
        }
        else
        {
            Managers.UI.OpenMainUI();
            Managers.UI.MainUI.OpenMainUI(MenuType.Map);
        }

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
        // Managers.UI.MainUI.SelectMenu((Managers.UI.MainUI.CurrentMenu + 1) / M);
    }
}
