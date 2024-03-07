using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum AttackPointType
{
    Default,
    Legs,
    Head
}

public class AttackPoint : MonoBehaviour
{
    [SerializeField] private AttackPointType type;
    private Monster monster;
    
    public AttackPointType Type => type;
    public Monster Monster => monster;

    private void Awake()
    {
        monster = GetComponentInParent<Monster>();
    }
}
