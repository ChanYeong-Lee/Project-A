using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum NavigationType
{
    Move,
    Confirm,
    Back,
    ShiftTab
}

public class NavigationSlot : MonoBehaviour
{
    [SerializeField] private NavigationType type;
    public NavigationType Type => type;
}
