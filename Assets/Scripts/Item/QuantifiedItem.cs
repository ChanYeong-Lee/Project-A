using System;
using UnityEngine;

public class QuantifiedItem : MonoBehaviour
{
    [SerializeField] protected Item data;
    [SerializeField] protected int count;
    
    public Item Data => data;
    public int Count { get => count; set => count = value; }
}