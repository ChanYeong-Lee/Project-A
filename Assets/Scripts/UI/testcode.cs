using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testcode : MonoBehaviour
{
    RectTransform rect;
    public RectTransform target;
    public float moveSpeed;
    public float moveTime;
    public Define.Direction dir;
    private void Awake()
    {
        rect = GetComponent<RectTransform>();   
    }
    private void Update()
    {
    }

    public void MoveDir()
    {
        StartCoroutine(AnimationHelper.Move(rect, dir, moveSpeed));
    }

    public void MoveToTarget()
    {
        StartCoroutine(AnimationHelper.Move(rect, new Vector2(0, 1000), moveTime));
    }
}
