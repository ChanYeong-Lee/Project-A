using System;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

[RequireComponent(typeof(PlayerInput))]
public class InputManager : MonoBehaviour
{
    private StarterAssets input;
    private InputAction selectedAction;
    
    public Vector2 move;
    public Vector2 look;
    public Vector2 mousePos;
    public bool jump;
    public bool sprint;
    public bool leftClick;
    public bool rightClick;
    public bool hKey;
    
    private bool isInteracting;
    private float moveUI;
    private float sortingMoveUI;

    public StarterAssets Input => input;
    public bool IsInteracting => isInteracting;
    public float MoveUI => moveUI;
    public float SortingMoveUI => sortingMoveUI;

    private void Awake()
    {
        input = new StarterAssets();
        
        // Player Move
        
        // Interaction
        input.Player.Interaction.performed += _ => isInteracting = true;
        input.Player.Interaction.canceled += _ => isInteracting = false;

        // Item Quick Slot
        input.Player.ItemQuickSlot1.performed += _ =>
            Managers.Game.Player.GetComponent<Player>()
                .UsePotion((Potion)Managers.Game.Inventory.FindItemData("SmallPotion"));

        input.Player.ItemQuickSlot2.performed += _ =>
            Managers.Game.Player.GetComponent<Player>()
                .UsePotion((Potion)Managers.Game.Inventory.FindItemData("MediumPotion"));

        input.Player.ItemQuickSlot3.performed += _ =>
            Managers.Game.Player.GetComponent<Player>()
                .UsePotion((Potion)Managers.Game.Inventory.FindItemData("LargePotion"));

        // UI
        // Inventory
        input.Player.Inventory.performed += _ =>
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
        };

        // Craft
        input.Player.Craft.performed += _ =>
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
        };

        // Quest
        input.Player.Quest.performed += _ =>
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
        };

        // Map
        input.Player.Map.performed += _ =>
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
        };

        // ESC & Settings
        input.Player.ESC.performed += _ =>
        {
            if (Managers.UI.IsOpenedUI)
            {
                Managers.UI.CloseMainUI();
            }
            else
            {
                Managers.UI.OpenMainUI();
                Managers.UI.MainUI.OpenMainUI(MenuType.Settings);
            }
        };

        // Tab
        input.Player.Tab.performed += _ =>
            Managers.UI.MainUI.SelectMenu((MenuType)(((int)Managers.UI.MainUI.CurrentMenu + 1) %
                                                     Enum.GetValues(typeof(MenuType)).Length));

        // UI Move - 상하 슬롯 선택
        input.Player.UIMove.started += context => moveUI = context.ReadValue<float>();
        input.Player.UIMove.performed += context => moveUI = 0;
        input.Player.UIMove.canceled += _ => moveUI = 0;
        
        // UI Move - 좌우 정렬 버튼 선택
        input.Player.UISortingMove.started += context => sortingMoveUI = context.ReadValue<float>();
        input.Player.UISortingMove.performed += context => sortingMoveUI = 0;
        input.Player.UISortingMove.canceled += _ => sortingMoveUI = 0;
    }

    private void OnEnable()
    {
        input.Enable();
        input.Player.Tab.Disable();
        input.Player.UIMove.Disable();
    }

    public void StopInputKey()
    {
        input.Disable();
    }

    public void OpenUI()
    {
        input.Player.Tab.Enable();
        input.Player.UIMove.Enable();
        input.Player.UISortingMove.Enable();
    }

    public void CloseUI()
    {
        input.Player.Tab.Disable();
        input.Player.UIMove.Disable();
        input.Player.UISortingMove.Disable();
    }
    
    #region MyRegion

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
    
    #endregion

    /*private bool ischeck;
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Mouse2))
        {
            ischeck = true;
        }

        if (ischeck)
        {
            ChangeKeyBinding(input.Player.Inventory);
        }
    }

    // 키 바인딩 바꾸기
    private void ChangeKeyBinding(InputAction action)
    {
        input.Disable();
        foreach (var key in Keyboard.current.allKeys)
        {
            if (key.wasPressedThisFrame)
            {
                Debug.Log(action.bindings[0].effectivePath);
                string prevBinding = $"{action.bindings[0].effectivePath}";
                string newBinding = $"<Keyboard>/{key.displayName.ToLower()}";
                
                foreach (InputBinding binding in input.bindings)
                {
                    if (binding.effectivePath == newBinding)
                    {
                        InputAction findAction = input.FindAction(binding.action);
                        findAction.ApplyBindingOverride(new InputBinding());
                        // input.FindAction(binding.action).ApplyBindingOverride(prevBinding, path: binding.effectivePath);
                        Debug.Log($"{findAction.bindings[0].overridePath}");
                        // break;
                    }
                }
                
                // action.RemoveBindingOverride(0);
                // action.AddBinding()
                action.ApplyBindingOverride(newBinding);
                Debug.Log($"prev : {prevBinding}, new : {newBinding}");
                ischeck = false;
                input.Enable();
                return;
            }
        }
    }*/
}