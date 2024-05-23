using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using static UnityEngine.ParticleSystem;

public class Arrow : Item
{
    [SerializeField] protected float moveSpeed = 30.0f;
    [SerializeField] protected TrailRenderer trail;
    [SerializeField] protected Transform arrowHead;
    public ArrowData ArrowData => data as ArrowData;
    protected Coroutine shotCoroutine;

    [SerializeField] protected GameObject[] explosionParticle;
    [SerializeField] protected GameObject[] trailParticle;

    protected Action onShotBegin;
    protected Action onShot;
    protected Action onShotEnd;


    // TODO : 보스 몬스터 및 몬스터 구현 후 효과 메소드 구현 예정
    // 화살 효과 발동 메소드
    public virtual void Attack()
    {

    }

    protected virtual void Awake()
    {
        foreach (GameObject gameObject in explosionParticle)
        {
            onShotEnd += () =>
            {
                GameObject particle = Managers.Resource.Instantiate(gameObject);
                particle.transform.position = gameObject.transform.position;
                particle.transform.rotation = gameObject.transform.rotation;
                particle.SetActive(true);
            };
        }

        foreach (GameObject gameObject in trailParticle)
        {
            onShotBegin += () =>
            {
                GameObject particle = Managers.Resource.Instantiate(gameObject, transform);
                particle.transform.position = gameObject.transform.position;
                particle.transform.rotation = gameObject.transform.rotation;

                particle.SetActive(true);
            };
        }
    }

    protected virtual void OnEnable()
    {
        trail.Clear();
        trail.enabled = false;
    }

    protected virtual void OnDisable()
    {
        if (shotCoroutine != null)
        {
            StopCoroutine(shotCoroutine);
            shotCoroutine = null;
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
        float lifeTime = 10.0f;
        
        while (true)
        {
            lifeTime -= Time.deltaTime;
            if (Vector3.Distance(target.transform.position, arrowHead.position) < 1.0f)
            {
                onShotEnd?.Invoke();
                target.Monster.TakeDamage(ArrowData, target.Type);
                break;
            }

            if (Physics.Raycast(arrowHead.position, transform.forward, out RaycastHit hit, 0.25f))
            {
                if (hit.collider.isTrigger == false)
                {
                    Monster newTarget = hit.collider.GetComponentInParent<Monster>();
                    
                    if (newTarget != null) 
                        newTarget.TakeDamage(ArrowData, AttackPointType.Default);
                    
                    onShotEnd?.Invoke();
                    break;
                }
            }

            if (lifeTime < 0.0f)
                break;

            onShot?.Invoke();

            transform.LookAt(target.transform);
            transform.position += transform.forward * moveSpeed * Time.deltaTime;

            yield return null;
        }

        trail.enabled = false;
        shotCoroutine = null;
        Managers.Pool.Push(gameObject);
    }
}
