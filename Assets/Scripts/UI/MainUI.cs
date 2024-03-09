using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public enum MenuType
{
    Inventory = 0,
    Crafting = 1,
    Quest = 2,
    Map = 3,
    Settings = 4,
}

public class MainUI : MonoBehaviour
{
    [SerializeField] private MainTab tab;
    [SerializeField] private MainContent content;
    [SerializeField] private MainNavigation navigation;

    private MenuType currentMenu;

    public MenuType CurrentMenu => currentMenu;

    private void Start()
    {
        foreach (TabElement element in tab.Tabs)
        {
            element.Button.onClick.AddListener(() => SelectMenu(element.Type));
        }
    }

    public void OpenMainUI(MenuType menuType)
    {
        currentMenu = menuType;
        
        tab.OpenMenu(menuType);
        content.SelectMenu(menuType);
        navigation.SelectMenu(menuType);
    }
    
    public void SelectMenu(MenuType menuType)
    {
        currentMenu = menuType;

        tab.SelectMenu(menuType);
        content.SelectMenu(menuType);
        navigation.SelectMenu(menuType);
    }
}

