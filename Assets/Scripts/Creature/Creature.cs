using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Creature : MonoBehaviour
{
    [SerializeField] protected StatData statData;
    [SerializeField] protected int currentLevel;
    
    protected Stat currentStat;
    
    public StatData StatData => statData;
    public int CurrentLevel { get => currentLevel; set => currentLevel = value; }
    public Stat CurrentStat { get => currentStat; set => currentStat = value; }

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        if (currentLevel < statData.Stats[0].Level || currentLevel > statData.Stats[^1].Level) 
            currentLevel = 1;
        
        currentStat = statData.Stats[currentLevel];
    }
}