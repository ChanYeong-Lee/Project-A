using UnityEngine;

[CreateAssetMenu(fileName = "New Arrow", menuName = "ScriptableObject/Item Data/Arrow")]
public class ArrowData : ItemData
{
    [Space(10)]
    [Header("Arrow Info")]
    [SerializeField] private Define.AttributeType attribute;
    [SerializeField] private int arrowDamage;
    [SerializeField] private int arrowTrueDamage;

    public Define.AttributeType Attribute => attribute;
    public int ArrowDamage => arrowDamage;
    public int ArrowTrueDamage => arrowTrueDamage;
}