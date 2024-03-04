using UnityEngine;

[CreateAssetMenu(fileName = "New Item", menuName = "ScriptableObject/Item Data/Item")]
public class ItemData : ScriptableObject
{
    [Header("Item Info")] 
    [SerializeField] protected int id;
    [SerializeField] protected string path;
    [SerializeField] protected string itemName;
    [SerializeField] protected Define.ItemType itemType;
    [SerializeField] protected int price;
    [SerializeField] [TextArea(1, 3)] protected string description;
    [SerializeField] protected Sprite icon;
    
    public int ItemID => id;
    public string Path => path;
    public string ItemName => itemName;
    public Define.ItemType ItemType => itemType;
    public int Price => price;
    public string Description => description;
    public Sprite Icon => icon;

}