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
    public AttackPointType Type => type;
}
