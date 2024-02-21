using System;
using System.Collections.Generic;
using UnityEngine;

public abstract class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected string envName;
    [SerializeField] protected bool isFarmable;
    [SerializeField] protected List<Item> dropItemList;
    
    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public List<Item> DropItemList { get => dropItemList; set => dropItemList = value; }
    
    public virtual void Init()
    {
        
    }


    public virtual void Farming()
    {
        
    }
}