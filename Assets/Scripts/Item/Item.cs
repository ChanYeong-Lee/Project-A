using System;
using UnityEngine;

public class Item : MonoBehaviour
{
    [SerializeField] protected ItemData data;
    [SerializeField] protected int count;
    
    public ItemData Data => data;
    public int Count { get => count; set => count = value; }

    public Item(ItemData data, int count)
    {
        this.data = data;
        this.count = count;
    }
}