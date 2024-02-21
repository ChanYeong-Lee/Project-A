using UnityEngine;

[CreateAssetMenu(fileName = "New Item", menuName = "ScriptableObject/Item Data/Item")]
public class ItemData : ScriptableObject
{
    [Header("Item Info")] 
    [SerializeField] protected int id;
    [SerializeField] protected string path;
    [SerializeField] protected string itemName;
    [SerializeField] protected Define.ItemType itemType;
    [SerializeField] [TextArea(1, 3)] protected string description;
    
    public int ItemID { get => id; set => id = value; }
    public string Path { get => path; set => path = value; }
    public string ItemName { get => itemName; set => itemName = value; }
    public Define.ItemType ItemType { get => itemType; set => itemType = value; }
    public string Description { get => description; set => description = value; }
}