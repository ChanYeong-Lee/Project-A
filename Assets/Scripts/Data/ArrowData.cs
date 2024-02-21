using UnityEngine;

[CreateAssetMenu(fileName = "New Arrow", menuName = "ScriptableObject/Item Data/Arrow")]
public class ArrowData : ItemData
{
    [SerializeField] private Define.AttributeType attribute;

    public Define.AttributeType Attribute { get => attribute; set => attribute = value; }
}