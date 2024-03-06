using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class Arrow : Item
{
    [SerializeField] private float moveSpeed = 30.0f;
    [SerializeField] private TrailRenderer trail;
    [SerializeField] private Transform arrowHead;
    public ArrowData ArrowData => data as ArrowData;
    private Coroutine shotCoroutine;

    [SerializeField] protected UnityEvent onShotBegin;
    [SerializeField] protected UnityEvent onShot;
    [SerializeField] protected UnityEvent onShotEnd;

    // TODO : 보스 몬스터 및 몬스터 구현 후 효과 메소드 구현 예정
    // 화살 효과 발동 메소드
    public virtual void Attack()
    {

    }

    protected virtual void OnEnable()
    {
        trail.Clear();
        trail.enabled = false;
    }

    private void OnDisable()
    {
        if (shotCoroutine != null)
        {
            StopCoroutine(shotCoroutine);
        }
    }

    public void Shot(AttackPoint target)
    {
        transform.LookAt(target.transform);
        shotCoroutine = StartCoroutine(ShotCoroutine(target));
    }

    protected IEnumerator ShotCoroutine(AttackPoint target)
    {
        onShotBegin?.Invoke();

        trail.enabled = true;
        float distance = Vector3.Distance(arrowHead.position, target.transform.position);
        
        while (true)
        {
            if (Vector3.Distance(arrowHead.position, target.transform.position) < 1.0f)
            {
                onShotEnd?.Invoke();
                yield return null;
                break;
            }

            onShot?.Invoke();

            transform.LookAt(target.transform);
            transform.position += transform.forward * moveSpeed * Time.deltaTime;

            yield return null;
        }

        Managers.Pool.Push(gameObject);
    }

}
