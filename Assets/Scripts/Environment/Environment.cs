using System;
using UnityEngine;

public abstract class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected string envName;
    [SerializeField] protected bool isFarmable;
    [SerializeField] protected Define.AttributeType attribute;
    
    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public Define.AttributeType Attribute => attribute;

    public virtual void Init()
    {
        
    }
    
    public virtual void Farming()
    {
        
    }
}