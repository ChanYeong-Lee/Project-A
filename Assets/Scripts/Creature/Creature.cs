using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Creature : MonoBehaviour
{
    [SerializeField] protected string creatureName;
    [SerializeField] protected List<Stat> statData;
    protected Stat currentStat;
    
    public string Name { get => creatureName; set => creatureName = value; }

    public List<Stat> StatData => statData;
    public Stat CurrentStat { get => currentStat; set => currentStat = value; }

    
    
    public virtual void Init()
    {
        
    }
    
}


[Serializable]
public class Stat
{
    [SerializeField] private int level;
    [SerializeField] private int healthPoint;
    [SerializeField] private int speed;
    
}