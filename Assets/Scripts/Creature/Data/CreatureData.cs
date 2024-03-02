using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Creature Data", menuName = "ScriptableObject/Creature Data/Creature Data")]
    
public class CreatureData : ScriptableObject
{
    [Space(10)]
    [Header("Creature Info")] 
    [SerializeField] protected string creatureName;
    [SerializeField] protected List<Stat> stats;

    public string CreatureName => creatureName;
    public List<Stat> Stats => stats;
}

[Serializable]
public class Stat
{
    [Tooltip("레벨")] [SerializeField] private int level;
    [Tooltip("생명력")] [SerializeField] private int healthPoint;
    [Tooltip("공격력")] [SerializeField] private int attack;
    [Tooltip("방어력")] [SerializeField] private int defence;

    public int Level { get => level; set => level = value; }
    public int HealthPoint { get => healthPoint; set => healthPoint = value; }
    public int Attack { get => attack; set => attack = value; }
    public int Defence { get => defence; set => defence = value; }
}