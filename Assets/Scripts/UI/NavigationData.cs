using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New NavigationData", menuName = "ScriptableObject/NavigationData")]
public class NavigationData : ScriptableObject
{
    [SerializeField] private MenuType type;
    [SerializeField] private List<NavigationType> navTypes;
    public MenuType Type => type;
    public List<NavigationType> NavTypes => navTypes;
}