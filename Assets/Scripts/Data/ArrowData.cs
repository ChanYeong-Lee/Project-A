using UnityEngine;

[CreateAssetMenu(fileName = "New Arrow", menuName = "ScriptableObject/Item Data/Arrow")]
public class ArrowData : ItemData
{
    [SerializeField] private Define.AttributeType attribute;
    [SerializeField] private int arrowDamage;

    public Define.AttributeType Attribute => attribute;
    public int ArrowDamage => arrowDamage;
}