using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public enum MenuType
{
    Inventory,
    Crafting,
    Map,
    Settings,
    Quest
}

public class MainUI : MonoBehaviour
{
    [SerializeField] private MainTab tab;
    [SerializeField] private MainContent content;
    [SerializeField] private MainNavigation navigation;

    private MenuType currentMenu;

    private void Start()
    {
        foreach (TabElement element in tab.Tabs)
        {
            element.Button.onClick.AddListener(() => SelectMenu(element.Type));
        }
    }

    public void SelectMenu(MenuType menuType)
    {
        currentMenu = menuType;

        tab.SelectMenu(menuType);
        content.SelectMenu(menuType);
        navigation.SelectMenu(menuType);
    }
}

