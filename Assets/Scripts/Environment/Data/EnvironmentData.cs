using UnityEngine;

[CreateAssetMenu(fileName = "New Env Data", menuName = "ScriptableObject/Env Data/Env Data")]
public class EnvironmentData : ScriptableObject
{
    [Header("Environment Info")]
    [SerializeField] private string envName;
    [SerializeField] private bool isFarmable;
    [SerializeField] private DropTableData dropItem;

    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public DropTableData DropItem => dropItem;
}