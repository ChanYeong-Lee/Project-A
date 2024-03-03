using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Creature : MonoBehaviour
{
    [SerializeField] protected CreatureData creatureData;
    [SerializeField] protected Vector3 spawnPos;
    [SerializeField] protected int currentLevel = 1;

    protected Stat currentStat;
     
    protected Animator anim;
    protected StateMachine stateMachine;

    public CreatureData CreatureData => creatureData;
    public Vector3 SpawnPos { get => spawnPos; set => spawnPos = value; }
    public int CurrentLevel { get => currentLevel; set => currentLevel = value; }
    public Stat CurrentStat { get => currentStat; set => currentStat = value; }
    public Animator Anim => anim;

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        stateMachine = gameObject.GetOrAddComponent<StateMachine>();
        anim = GetComponent<Animator>();

        if (creatureData is null || creatureData.Stats.Count == 0)
            return;
        
        if (currentLevel < creatureData.Stats[0].Level || currentLevel > creatureData.Stats[^1].Level)
            currentLevel = 1;

        currentStat = new Stat(creatureData.Stats[currentLevel]);
    }
}

// 코드 길어지면 분리
namespace CreatureController
{
    public abstract class CreatureState : BaseState
    {
        protected Creature owner;
        protected Animator anim => owner.Anim;
        protected Vector3 spawnPos => owner.SpawnPos;

        public CreatureState(Creature owner)
        {
            this.owner = owner;
        }
    }
}

