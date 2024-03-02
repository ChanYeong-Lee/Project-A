using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum MenuType
{
    Inventory,
    Crafting,
    Map,
    Settings,
    Exit
}

public class MainUI : MonoBehaviour
{
    [SerializeField] private MainTab tab;
    [SerializeField] private MainNavigation navigation;



}

