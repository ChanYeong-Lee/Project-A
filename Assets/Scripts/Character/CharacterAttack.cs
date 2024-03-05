using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterAttack : MonoBehaviour
{
    public enum AttackState 
    {
    }

    private AttackState state;
    public AttackState State => state;

    private Define.AttributeType arrowType;
    public Define.AttributeType ArrowType => arrowType;

}
